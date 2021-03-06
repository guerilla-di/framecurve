require File.dirname(__FILE__) + '/helper'

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
  
  def test_parse_with_neg_source_frame
    data = "10\t-1293.12"
    elements = Framecurve::Parser.new.parse(StringIO.new(data))
    assert_kind_of Framecurve::Curve, elements
    
    assert_equal 1, elements.length
    assert_kind_of Framecurve::Tuple, elements[0]
    assert_equal Framecurve::Tuple.new(10, -1293.12), elements[0]
  end
  
  def test_parse_with_neg_dest_frame
    data = "-123\t-1293.12"
    elements = Framecurve::Parser.new.parse(StringIO.new(data))
    assert_kind_of Framecurve::Curve, elements
    
    assert_equal 1, elements.length
    assert_kind_of Framecurve::Tuple, elements[0]
    assert_equal Framecurve::Tuple.new(-123, -1293.12), elements[0]
  end
  
  def test_should_try_to_open_file_at_path_if_string_passed_to_parse
    v = Framecurve::Parser.new
    assert !File.exist?("/tmp/some_file.framecurve.txt")
    assert_raise(Errno::ENOENT) do
      v.parse("/tmp/some_file.framecurve.txt")
    end
  end
  
  def test_should_pick_file_path_from_passed_file_object
    v = Framecurve::Parser.new
    path = File.dirname(__FILE__) + "/fixtures/framecurves/sample_framecurve1.framecurve.txt"
    File.open(path) do | f |
      curve = v.parse(f)
      assert_equal "sample_framecurve1.framecurve.txt", curve.filename
    end
  end
  
  def test_parser_fails_on_malformed_lines
    data = "Sachlich gesehen\nbambam"
    assert_raise(Framecurve::Malformed) do
      Framecurve::Parser.new.parse(StringIO.new(data))
    end
  end
  
end
