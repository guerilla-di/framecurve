require 'helper'

class TestFramecurveParser < Test::Unit::TestCase
  def test_parser
    data = ["# Framecurve data", "10\t1293.12", "#Some useful info", "10\t145"].join("\r\n")
    p = Framecurve::Parser.new
    elements = p.parse(StringIO.new(data))
    assert_kind_of Framecurve::Curve, elements
    
    assert_equal 4, elements.length
    
    assert_kind_of Framecurve::Comment, elements[0]
    assert_kind_of Framecurve::Tuple, elements[1]
    assert_kind_of Framecurve::Comment, elements[2]
    assert_kind_of Framecurve::Tuple, elements[3]
    
    assert_equal "Framecurve data", elements[0].text
    assert_equal Framecurve::Tuple.new(10, 1293.12), elements[1]
    assert_equal "Some useful info", elements[2].text
  end
  
  def test_should_try_to_open_file_at_path_if_string_passed_to_parse
    v = Framecurve::Parser.new
    assert !File.exist?("/tmp/some_file.framecurve.txt")
    assert_raise(Errno::ENOENT) do
      v.parse("/tmp/some_file.framecurve.txt")
    end
  end
  
  def test_parser_fails_on_malformed_lines
    data = "Sachlich gesehen\nbambam"
    assert_raise(Framecurve::Malformed) do
      Framecurve::Parser.new.parse(StringIO.new(data))
    end
  end
  
  def test_parser_fails_with_only_lf_linefeed_instead_of_crlf
    data = ["# Framecurve data", "10\t1293.12", "#Some useful info", "10\t145"].join("\n")
    assert_raise(Framecurve::Malformed) do
      Framecurve::Parser.new.parse(StringIO.new(data))
    end
  end
end
