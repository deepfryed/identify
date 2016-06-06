require 'bundler/setup'

require 'identify'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe 'Identify' do
  def magick file
    format, width, height = %x{identify #{file}}.split(/\s+/)[1..2].map {|v| v.split(/(?<=\d)x/)}.flatten
    {width: width.to_i, height: height.to_i, format: format.downcase.sub(%r{bmp3}, 'bmp')}
  end

  Dir[File.dirname(__FILE__) + '/images/*'].each do |file|
    it "should identify image #{File.basename(file)}" do
      assert_equal magick(file), Identify.image(File.binread(file)), file
    end
  end
end
