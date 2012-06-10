module Identify
  VERSION = '0.1.1'

  def self.image data
    Image.identify(data)
  end

  class Image
    def self.formats
      @formats ||= []
    end

    def self.inherited klass
      formats << klass
    end

    def self.identify data
      format = formats.find {|klass| klass.handle? data}
      format ? format.parse(data) : {}
    end

    def self.parse data
      new.parse data
    end

    def as_hash format, width, height
      {width: width.to_i, height: height.to_i, format: format}
    end

    class XPM < Image
      def self.handle? data
        %r{\A#{Regexp.escape('/* XPM */')}}.match(data)
      end

      def parse data
        as_hash 'xpm', *data.scan(%r{"(\d+)\s+(\d+)(?=[\s\d]+")}).flatten
      end
    end

    class PCX < Image
      def self.handle? data
        data[0].ord == 10
      end

      def parse data
        header = data.unpack('C4S4')
        as_hash 'pcx', header[6] - header[4] + 1, header[7] - header[5] + 1
      end
    end # PCX

    class TIFF < Image
      def self.handle? data
        data[0..3] == "MM\x00\x2a" || data[0..3] == "II\x2a\x00"
      end

      def parse data
        endian  = data[0..1] == "MM" ? 'n' : 'v'
        # IFD offset
        offset  = data.unpack("x4#{endian.upcase}").first
        # Don't have enough header data
        return {} if data.bytesize < offset + 14

        nrec    = data[offset, 2].unpack(endian).first
        offset += 2
        height  = nil
        width   = nil
        types   = [nil, 'C', nil, endian, endian.upcase]

        while nrec > 0 && data.bytesize > offset + 12
          ifd  = data[offset, 12]
          type = ifd.unpack("x2#{endian}").first
          case ifd.unpack(endian).first
            when 0x0100
              width  = ifd[8, 4].unpack(types[type]).first
            when 0x0101
              height = ifd[8, 4].unpack(types[type]).first
          end
          nrec   -= 1
          offset += 12

          break if width && height
        end
        as_hash 'tiff', width, height
      end
    end # TIFF

    class BMP < Image
      def self.handle? data
        %r{\ABM}.match(data)
      end

      def parse data
        as_hash 'bmp', *data.unpack("x18VV")
      end
    end # BMP

    class PBM < Image
      def self.handle? data
        %r{\AP[1-6]}.match(data)
      end

      def parse data
        type, dims = data[0..4096].split(/\n+/).reject {|line| %r{\A#}.match(line)}.take(2)
        as_hash format(type), *dims.split(/\s+/)
      end

      def format type
        case type
          when 'P1', 'P4' then 'pbm'
          when 'P2', 'P5' then 'pgm'
          when 'P3', 'P6' then 'ppm'
        end
      end
    end # PBM

    class XBM < Image
      def self.handle? data
        %r{\A#define\s+.*width}i.match(data)
      end

      def parse data
        as_hash 'xbm', *data.scan(%r{^#define\s+.*?_(?:width|height)\s+(\d+)}).flatten
      end
    end

    class GIF < Image
      def self.handle? data
        data.start_with?("GIF89a", "GIF87a")
      end

      def parse data
        as_hash('gif', *data.unpack("x6vv"))
      end
    end # GIF

    class PNG < Image
      def self.handle? data
        data[0..7] == "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A" # png 8-byte signature
      end

      def parse data
        {}.tap do |meta|
          meta.merge! as_hash('png', *data.unpack("x16NN")) if data[12..15] == "IHDR"
        end
      end
    end # PNG

    class JFIF < Image
      # http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/JPEG.html#SOF
      SOF = [0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf]

      def self.handle? data
        data.index("JFIF", 4) == 6
      end

      def parse data
        index = 4
        block = data[index].ord * 256 + data[index + 1].ord

        {}.tap do |meta|
          while (index += block) < data.size
            break unless data[index].ord == 0xff
            if SOF.include?(data[index + 1].ord)
              meta.merge! as_hash('jpeg', *data.unpack("x#{index + 5}nn").reverse)
              break
            else
              index += 2
              block  = data[index].ord * 256 + data[index + 1].ord
            end
          end
        end
      end
    end # JFIF
  end # Image
end # Identify
