require 'helper'
require "fileutils"

class TestFramecurveFromFCPXML < Test::Unit::TestCase
  BINARY = File.expand_path(File.dirname(__FILE__) + "/../bin/framecurve_from_fcp_xml")
  FILE_PATH = File.expand_path(File.dirname(__FILE__) + "/fixtures/CountDOWN.xml")
  
  # Run the binary under test with passed options, and return [exit_code, stdout_content, stderr_content]
  def cli(commandline_arguments)
    CLITest.new(BINARY).run(commandline_arguments)
  end
  
  def teardown
    Dir.glob(File.expand_path(File.dirname(__FILE__) + "/ConuntDown-RSZ*")).each do | f |
      File.unlink(f)
    end
  end
  
  def test_cli_with_valid_file
    s, o, e = cli(FILE_PATH)
    assert_equal 0, s
    assert e.include?("timewarp")
    
    curve = Framecurve::Parser.new.parse("ConuntDown-RSZ.framecurve.txt")
    assert_equal 91, curve.length
    assert_equal Framecurve::Tuple.new(1, 1.0), curve[2]
    assert_equal Framecurve::Tuple.new(14, 2.625), curve[15]
    
    curve2 = Framecurve::Parser.new.parse("ConuntDown-RSZ-1.framecurve.txt")
    puts curve.inspect
    assert_equal 91, curve.length
    
  end
  
end