require 'minitest/spec'

class MiniTest::Spec < MiniTest::Unit::TestCase
  class << self
    alias :__it :it

    def method_description
      @method_description ||= {}
    end

    def it desc, &block
      before = public_instance_methods
      __it(desc, &block).tap do
        method = public_instance_methods - before
        method_description[method.first.to_s] = desc
      end
    end
  end
end

class MiniTest::Pretty < MiniTest::Unit
  def _run_suite suite, type
    header = "#{type}_suite_header"
    puts send(header, suite) if respond_to? header

    filter = options[:filter] || '/./'
    filter = Regexp.new $1 if filter =~ /\/(.*)\//

    puts "#{suite}" if suite != MiniTest::Spec
    assertions = suite.send("#{type}_methods").grep(filter).map do |method|
      inst = suite.new method
      inst._assertions = 0

      @start_time = Time.now
      result = inst.run self
      time = Time.now - @start_time

      print '    '
      print '%s' % (result == '.' ? green('OK') : red('FAIL'))
      print '%6s'  % ('%.2fs' % time)
      print ' | '
      puts "#{suite.method_description[method]}"

      inst._assertions
    end

    return assertions.size, assertions.inject(0) {|sum, n| sum + n}
  end

  def red text, padding = 6
    $stdout.tty? ? "\e[1;31m#{"%-#{padding}s" % text}\e[0m" : text
  end

  def green text, padding = 6
    $stdout.tty? ? "\e[1;32m#{"%-#{padding}s" % text}\e[0m" : text
  end

end

MiniTest::Unit.runner = MiniTest::Pretty.new
