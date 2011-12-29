require 'helper'

class TestFramecurveValidator < Test::Unit::TestCase
  def test_should_init_with_empty_errors_and_warnings
    v = Framecurve::Validator.new
    assert !v.any_errors?
    assert !v.any_warnings?
    assert_equal [], v.errors
    assert_equal [], v.warnings
  end
  
  def test_should_error_out_with_empty
    v = Framecurve::Validator.new
    v.validate([])
    assert v.any_errors?
    assert_equal [], v.errors
  end
  
  def test_should_error_out_without_actual_tuples
    c = Framecurve::Curve.new( Framecurve::Comment.new("Only text") )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    assert_equal [], v.errors
  end
  
  def test_should_error_out_with_frames_out_of_sequence
    c = Framecurve::Curve.new( Framecurve::Tuple.new(10, 123.4), Framecurve::Tuple.new(10, 123.4) )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    assert_equal [], v.errors
  end
end