require 'helper'

class TestFramecurveTuple < Test::Unit::TestCase
  def test_initialization
    t = Framecurve::Tuple.new(123, 645.1458)
    assert_equal 123, t.at
    assert_equal 645.1458, t.value
    assert_equal "123\t645.145800", t.to_s
  end
  
  def test_not_comment
    assert !Framecurve::Tuple.new.comment?
    assert Framecurve::Tuple.new.tuple?
  end
end