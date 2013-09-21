require 'spec_helper'

describe Ryeppp do
  # Addition
  it 'should add vectors of Fixnums' do
    Ryeppp.add_v64sv64s_v64s([1], [2]).should eq([3])
    expect{Ryeppp.add_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
  end
  it 'should add vectors of Floats' do
    Ryeppp.add_v64fv64f_v64f([1.1], [1.1]).should eq([2.2])
    expect{Ryeppp.add_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
  end

  # Subtraction
  it 'should subtract vectors of Fixnums' do
    Ryeppp.subtract_v64sv64s_v64s([1], [2]).should eq([-1])
    expect{Ryeppp.subtract_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
  end
  it 'should subtract vectors of Floats' do
    Ryeppp.subtract_v64fv64f_v64f([1.1], [1.1]).should eq([0])
    expect{Ryeppp.subtract_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
  end

  # Multiplication
  it 'should multiply a vector of Fixnums' do
    Ryeppp.multiply_v64ss64s_v64s([1, 2, 3], 2).should eq([2, 4, 6])
    expect{Ryeppp.multiply_v64ss64s_v64s([1, 'a'], 2)}.to raise_error(TypeError)
  end
  it 'should multiply a vector of Floats' do
    Ryeppp.multiply_v64fs64f_v64f([1.0, 2.0, 3.0], 2.0).should eq([2.0, 4.0, 6.0])
    expect{Ryeppp.multiply_v64fs64f_v64f([1, 'a'], 2)}.to raise_error(TypeError)
  end
  it 'should multiply vectors of Fixnums' do
    Ryeppp.multiply_v64sv64s_v64s([2], [3]).should eq([6])
    expect{Ryeppp.multiply_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
  end
  it 'should multiply vectors of Floats' do
    Ryeppp.multiply_v64fv64f_v64f([2.5], [3.5]).should eq([8.75])
    expect{Ryeppp.multiply_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
  end

  # Dot Product
  it 'should do the dot product' do
    Ryeppp.dotproduct_v64fv64f_s64f([1, 2, 3], [4, 5, 6]).should eq(32.0)
    expect{Ryeppp.dotproduct_v64fv64f_s64f([1, 2, 'a'], [4, 5, 'b'])}.to raise_error(TypeError)
  end

  # Minimum
  it 'should find the minimum in a vector of Fixnums' do
    Ryeppp.min_v64s_s64s([3, 2, 1]).should eq(1)
    expect{Ryeppp.min_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
  end
  it 'should find the minimum in a vector of Floats' do
    Ryeppp.min_v64f_s64f([1.0, 2.0, 3.0]).should eq(1.0)
    expect{Ryeppp.min_v64f_s64f([1.0, 'a'])}.to raise_error(TypeError)
  end

  # Maximum
  it 'should find the maximum in a vector of Fixnums' do
    Ryeppp.max_v64s_s64s([3, 2, 1]).should eq(3)
    expect{Ryeppp.max_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
  end
  it 'should find the maximum in a vector of Floats' do
    Ryeppp.max_v64f_s64f([1.0, 2.0, 3.0]).should eq(3.0)
    expect{Ryeppp.max_v64f_s64f([1.0, 'a'])}.to raise_error(TypeError)
  end

  # Pairwise Minima
  it 'should find the pairwise minima in vectors of Floats' do
    Ryeppp.min_v64fv64f_v64f([1.0, 2.0, 3.0], [3.0, 2.0, 1.0]).should eq([1.0, 2.0, 1.0])
    expect{Ryeppp.min_v64fv64f_v64f([1.0, 'a'], [2.0, 'b'])}.to raise_error(TypeError)
  end
  # Pairwise Maxima
  it 'should find the maximum in a vector of Floats' do
    Ryeppp.max_v64fv64f_v64f([1.0, 2.0, 3.0], [3.0, 2.0, 1.0]).should eq([3.0, 2.0, 3.0])
    expect{Ryeppp.max_v64fv64f_v64f([1.0, 'a'], [2.0, 'b'])}.to raise_error(TypeError)
  end

  # Constant Minima
  it 'should find the minima in a vector of Floats and a constant' do
    Ryeppp.min_v64fs64f_v64f([1.0, 2.0, 3.0], 2.0).should eq([1.0, 2.0, 2.0])
    expect{Ryeppp.min_v64fs64f_v64f([1.0, 'a'], 2.0)}.to raise_error(TypeError)
  end
  # Constant Maxima
  it 'should find the maxima in a vector of Floats and a constant' do
    Ryeppp.max_v64fs64f_v64f([1.0, 2.0, 3.0], 2.5).should eq([2.5, 2.5, 3.0])
    expect{Ryeppp.max_v64fs64f_v64f([1.0, 'a'], 2.5)}.to raise_error(TypeError)
  end

  # Negation
  it 'should negate vectors of Fixnums' do
    Ryeppp.negate_v64s_s64s([1]).should eq([-1])
    expect{Ryeppp.negate_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
  end
  it 'should negate vectors of Floats' do
    Ryeppp.negate_v64f_s64f([1.1]).should eq([-1.1])
    expect{Ryeppp.negate_v64f_s64f([1.1, 'a'])}.to raise_error(TypeError)
  end

  # Sum
  it 'should sum a vector' do
    Ryeppp.sum_v64f_s64f([1, 2, 3]).should eq(6.0)
    expect{Ryeppp.sum_v64f_s64f([1, 'a'])}.to raise_error(TypeError)
  end
  # Sum Absolute Values
  it 'should sum absolute values of a vector' do
    Ryeppp.sumabs_v64f_s64f([1.0, -1.0, 2.0]).should eq(4.0)
    expect{Ryeppp.sumabs_v64f_s64f([1.0, -1.0, 'a'])}.to raise_error(TypeError)
  end
  # Sum Square Values
  it 'should sum square values of a vector' do
    Ryeppp.sumsquares_v64f_s64f([1.0, -1.0, 2.0]).should eq(6.0)
    expect{Ryeppp.sumsquares_v64f_s64f([1.0, -1.0, 'a'])}.to raise_error(TypeError)
  end

  # Log
  it 'should find the natural logarithm of elements of a vector' do
    Ryeppp.log_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}.should eq([0.0, 0.69315, 1.09861])
    expect{Ryeppp.log_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
  end
  # Exp
  it 'should find the base e exponent of elements of a vector' do
    Ryeppp.exp_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}.should eq([2.71828, 7.38906, 20.08554])
    expect{Ryeppp.exp_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
  end
  # Sin
  it 'should find the sine of elements of a vector' do
    Ryeppp.sin_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}.should eq([0.84147, 0.9093, 0.14112])
    expect{Ryeppp.sin_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
  end
  # Cos
  it 'should find the cosine of elements of a vector' do
    Ryeppp.cos_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}.should eq([0.5403, -0.41615, -0.98999])
    expect{Ryeppp.cos_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
  end
  # Tan
  it 'should find the tangent of elements of a vector' do
    Ryeppp.tan_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}.should eq([1.55741, -2.18504, -0.14255])
    expect{Ryeppp.tan_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
  end

  # Polynomial
  it 'should evaluate a polynomial for a vector' do
    # x^2 + x + 1
    # evaluated at x=1.
    Ryeppp.evaluatepolynomial_v64fv64f_v64f([1.0, 1.0, 1.0], [1.0]).should eq([3.0])
    # -5x^3 - 4x^2 + 2x + 1
    # evaluated at x=0, x=1, and x=2.
    Ryeppp.evaluatepolynomial_v64fv64f_v64f([-5, -4, 2, 1], [0, 1, 2]).should eq([-5.0, -6.0, 3.0])
    expect{Ryeppp.evaluatepolynomial_v64fv64f_v64f([1, 'a'], [0, 1])}.to raise_error(TypeError)
  end
end
