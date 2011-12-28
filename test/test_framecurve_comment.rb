require 'helper'

class TestFramecurveComment < Test::Unit::TestCase
  def test_not_tuple
    assert Framecurve::Comment.new.comment?
    assert !Framecurve::Comment.new.tuple?
  end
  
  def test_initialization
    c = Framecurve::Comment.new("Very interesting \r\n comment")
    assert_equal "Very interesting \r\n comment", c.text
    assert_equal "# Very interesting  comment", c.to_s
  end
  
  def test_initialization_with_nil_produces_usable_to_s
    c = Framecurve::Comment.new(nil)
    assert_equal "# ", c.to_s
  end
end