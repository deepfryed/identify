# Identify

A pure ruby image identification library.

## Install

`gem install identify`

## Supported Formats

BMP, PNG, JPG, GIF, XPM, PPM, PGM, PNM, PBM, XBM, TIFF

## Example

```ruby
require 'identify'

p Identify.image File.binread("test/images/test.png", 1024)
```

### Output

```
{:width=>253, :height=>178, :format=>"png"}
```

## Testing

Tests require a local installation of ImageMagick and `identify` to be in your `$PATH`

## TODO

Channel type, Depth, Colorspace and Resolution.

# See Also
[http://rubygems.org/gems/imagesize](http://rubygems.org/gems/imagesize)

# License
MIT
