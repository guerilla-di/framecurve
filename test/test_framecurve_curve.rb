require 'helper'

class TestFramecurveCurve < Test::Unit::TestCase
  def test_init_with_empty_array
    c = Framecurve::Curve.new([])
    assert c.empty?
    assert !c.any?
  end
  
  def test_init_with_no_arguments
    c = Framecurve::Curve.new
    assert c.empty?
    assert !c.any?
  end
  
  def test_init_with_one_tuple
    c = Framecurve::Curve.new( Framecurve::Tuple.new(10, 123))
    assert !c.empty?
    assert_equal 1, c.length
    items = c.to_a
    assert_equal [Framecurve::Tuple.new(10, 123)], c.to_a
  end
  
  def test_each_tuple
    c = Framecurve::Curve.new( Framecurve::Comment.new("Welcome"), Framecurve::Tuple.new(10, 123))
    assert !c.empty?
    assert_equal 2, c.length
    tuples = []
    c.each_tuple(&tuples.method(:push))
    assert_equal [Framecurve::Tuple.new(10, 123)], tuples
  end
  
  def test_only_tuples
    c = Framecurve::Curve.new( Framecurve::Comment.new("Welcome"), Framecurve::Tuple.new(10, 123))
    assert !c.empty?
    tuples = c.only_tuples
    assert_equal [Framecurve::Tuple.new(10, 123)], tuples
  end
  
  def test_each_comment
    c = Framecurve::Curve.new( Framecurve::Comment.new("Welcome"), Framecurve::Tuple.new(10, 123))
    assert !c.empty?
    comments = []
    c.each_comment(&comments.method(:push))
    assert_equal [Framecurve::Comment.new("Welcome")], comments
  end
  
  def test_subscript
    c = Framecurve::Curve.new( Framecurve::Comment.new("Welcome"), Framecurve::Tuple.new(10, 123))
    assert_equal Framecurve::Comment.new("Welcome"), c[0]
    assert_equal Framecurve::Tuple.new(10, 123), c[1]
  end
  
  def test_comment!
    c = Framecurve::Curve.new
    c.comment!("Also")
    assert !c.empty?
    assert_equal Framecurve::Comment.new("Also"), c[0]
  end
  
  def test_tuple!
    c = Framecurve::Curve.new
    c.tuple!(10, 123.45)
    assert !c.empty?
    assert_equal Framecurve::Tuple.new(10, 123.45), c[0]
  end
  
  def test_raises_malformed_with_tuple_at_duplicate_frame
    c = Framecurve::Curve.new
    c.tuple!(10, 123.45)
    assert_raise(Framecurve::Malformed) do
      c.tuple!(10, 456.45)
    end
  end
  
  def test_filaneme_accessor
    c = Framecurve::Curve.new
    assert_nil c.filename
    c.filename = "foo.framecurve.txt"
    assert_equal "foo.framecurve.txt", c.filename
  end
  
  def test_teach_defined_tuple
    c = Framecurve::Curve.new(Framecurve::Tuple.new(1, 123.45), Framecurve::Tuple.new(10, 567.89))
    concrete = []
    c.each_defined_tuple(&concrete.method(:push))
    ref = [
      Framecurve::Tuple.new(1, 123.450000),
      Framecurve::Tuple.new(2, 172.83222222222224),
      Framecurve::Tuple.new(3, 222.21444444444444),
      Framecurve::Tuple.new(4, 271.5966666666667),
      Framecurve::Tuple.new(5, 320.9788888888889),
      Framecurve::Tuple.new(6, 370.36111111111114),
      Framecurve::Tuple.new(7, 419.74333333333334),
      Framecurve::Tuple.new(8, 469.12555555555554),
      Framecurve::Tuple.new(9, 518.5077777777778),
      Framecurve::Tuple.new(10, 567.89),
    ]
    assert_equal ref, concrete
  end
  
  def test_materialized_curve
    c = Framecurve::Curve.new(Framecurve::Tuple.new(1, 123.45), Framecurve::Tuple.new(10, 567.89))
    materialized = c.to_materialized_curve
    assert_equal 12, materialized.length
  end
end