require File.dirname(__FILE__) + '/helper'
require "fileutils"

class TestFramecurveValidatorBinary < Test::Unit::TestCase
  BINARY = File.expand_path(File.dirname(__FILE__) + "/../bin/framecurve_validator")
  GOOD_FC_PATH = "simple.framecurve.txt"
  BAD_FC_PATH = "crap"
  
  # Run the binary under test with passed options, and return [exit_code, stdout_content, stderr_content]
  def cli(commandline_arguments)
    CLITest.new(BINARY).run(commandline_arguments)
  end
  
  def setup
    File.open(GOOD_FC_PATH, "wb") do | f |
      c = Framecurve::Curve.new(Framecurve::Tuple.new(10, 123.45))
      Framecurve::Serializer.new.serialize(f, c)
    end
    
    File.open(BAD_FC_PATH, "wb") do | f |
      f.write("This is gibberish")
    end
  end
  
  def teardown
    File.unlink(GOOD_FC_PATH) if File.exist?(GOOD_FC_PATH)
    File.unlink(BAD_FC_PATH) if File.exist?(BAD_FC_PATH)
    File.unlink(GOOD_FC_PATH + ".tmp") if File.exist?(GOOD_FC_PATH + ".tmp")
  end
  
  def test_cli_with_valid_file
    s, o, e = cli(File.expand_path(GOOD_FC_PATH))
    assert_equal 0, s
    assert o.include?("OK!")
    assert_equal '', e
  end
  
  def test_cli_with_bad_file
    s, o, e = cli(File.expand_path(BAD_FC_PATH))
    assert_equal 10, s, "The exit status on fail should not be 0"
    assert e.include?("ERRORS")
  end
  
  def test_cli_with_bad_filename_extension
    FileUtils.cp(GOOD_FC_PATH, GOOD_FC_PATH + ".tmp")
    s, o, e = cli(File.expand_path(GOOD_FC_PATH + ".tmp"))
    assert_equal 10, s, "The exit status on fail should not be 0"
    assert e.include?("but had \".tmp\"")
  end
  
end