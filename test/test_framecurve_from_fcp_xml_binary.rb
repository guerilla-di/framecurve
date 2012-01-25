require 'helper'
require "fileutils"

class TestFramecurveFromFCPXML < Test::Unit::TestCase
  BINARY = File.expand_path(File.dirname(__FILE__) + "/../bin/framecurve_from_fcp_xml")
  FILE_PATH = File.expand_path(File.dirname(__FILE__) + "/fixtures/fcp_xml/CountDOWN.xml")
  HERE = File.expand_path(File.dirname(__FILE__))
  
  # Run the binary under test with passed options, and return [exit_code, stdout_content, stderr_content]
  def cli(commandline_arguments)
    CLITest.new(BINARY).run(commandline_arguments)
  end
  
  def teardown
    Dir.glob(File.dirname(FILE_PATH) + "/*.framecurve.txt").each do | f |
      File.unlink(f)
    end
  end
  
  def test_cli_with_valid_file
    s, o, e = cli(FILE_PATH)
    
    assert_equal 0, s
    assert e.include?("timewarp")
    
    curve = Framecurve::Parser.new.parse(HERE + "/fixtures/fcp_xml/CountDOWN.xml.SEQ1-V1-CLIP1.framecurve.txt")
    
    assert_equal 11, curve.length
    assert_match /From FCP XML/, curve[2].text
    assert_equal "Information from /xmeml/project/children/sequence/media/video/track/clipitem[1]", curve[3].text
    
    assert_equal Framecurve::Tuple.new(1, 13.0), curve[4]
    assert_equal Framecurve::Tuple.new(51, 63.0), curve[-1]
    
    curve2 = Framecurve::Parser.new.parse(HERE + "/fixtures/fcp_xml/CountDOWN.xml.SEQ1-V1-CLIP3.framecurve.txt")
    assert_equal 11, curve.length
    
  end
  
end