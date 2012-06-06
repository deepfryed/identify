# Identify

A pure ruby image identification library.

## Supported Formats

* BMP
* PNG
* JPG
* GIF
* XPM
* PPM
* PGM
* PNM
* PBM
* XBM
* TIFF

## Example

```ruby
require 'identify'

Identify.image File.binread("test/images/test.png", 1024) #=> {:format => "png", :width => 253, :height => 178}

```

## Testing

Tests require a local installation of ImageMagick and `identify` to be in your `$PATH`

# See Also
[http://rubygems.org/gems/imagesize](http://rubygems.org/gems/imagesize)

# License
[Creative Commons Attribution - CC BY](http://creativecommons.org/licenses/by/3.0)
