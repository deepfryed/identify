# -*- encoding: utf-8 -*-
# stub: identify 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "identify"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bharanee Rathna"]
  s.date = "2016-05-12"
  s.description = "Image identification in pure Ruby"
  s.email = ["deepfryed@gmail.com"]
  s.files = ["CHANGELOG", "README.md", "lib/identify.rb"]
  s.homepage = "http://github.com/deepfryed/identify"
  s.rubygems_version = "2.2.2"
  s.summary = "Identify image types and dimensions"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
