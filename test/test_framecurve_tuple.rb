require File.dirname(__FILE__) + '/helper'

class TestFramecurveTuple < Test::Unit::TestCase
  def test_initialization
    t = Framecurve::Tuple.new(123, 645.1458)
    assert_equal 123, t.at
    assert_equal 645.1458, t.value
    assert_equal "123\t645.14580", t.to_s
  end
  
  def test_not_comment
    assert !Framecurve::Tuple.new.comment?
    assert Framecurve::Tuple.new.tuple?
  end
  
  def test_vlidates_equality_to_5_decimal_places
    t = Framecurve::Tuple.new(1, 1234.567890)
    t2 = Framecurve::Tuple.new(1, 1234.567891)
    t3 = Framecurve::Tuple.new(1, 1234.567884)
    
    assert_equal t, t2
    assert_not_equal t, t3
  end
end