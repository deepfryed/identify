# encoding: utf-8

$:.unshift File.dirname(__FILE__) 

require 'date'
require 'pathname'
require 'rake'
require 'rake/testtask'
require 'lib/identify'

$rootdir = Pathname.new(__FILE__).dirname
$gemspec = Gem::Specification.new do |s|
  s.name              = 'identify'
  s.version           = Identify::VERSION
  s.date              = Date.today    
  s.authors           = ['Bharanee Rathna']
  s.email             = ['deepfryed@gmail.com']
  s.summary           = 'Identify image types and dimensions'
  s.description       = 'Image identification in pure Ruby'
  s.homepage          = 'http://github.com/deepfryed/identify'
  s.files             = Dir['{lib}/**/*.rb'] + %w(README.md CHANGELOG)
  s.require_paths     = %w(lib)

  s.add_development_dependency('rake')
end

desc 'Generate gemspec'
task :gemspec do 
  $gemspec.date = Date.today
  File.open("#{$gemspec.name}.gemspec", 'w') {|fh| fh.write($gemspec.to_ruby)}
end

Rake::TestTask.new(:test) do |test|
  test.libs   << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task default: :test
