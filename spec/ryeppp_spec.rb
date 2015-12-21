require 'spec_helper'

SMALLEST_TOO_BIG_INTEGER = 2**63
BIGGEST_TOO_SMALL_INTEGER = -2**63 - 1

describe Ryeppp do
  # Addition
  it 'should add vectors of Fixnums' do
    expect(Ryeppp.add_v64sv64s_v64s([1], [2])).to eq([3])
    expect{Ryeppp.add_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.add_v64sv64s_v64s([SMALLEST_TOO_BIG_INTEGER], [1])}.to raise_error(RangeError)
    expect{Ryeppp.add_v64sv64s_v64s([BIGGEST_TOO_SMALL_INTEGER], [1])}.to raise_error(RangeError)
    expect{Ryeppp.add_v64sv64s_v64s([1], [2, 3])}.to raise_error(ArgumentError)
  end
  it 'should add vectors of Floats' do
    expect(Ryeppp.add_v64fv64f_v64f([1.1], [1.1])).to eq([2.2])
    expect{Ryeppp.add_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.add_v64fv64f_v64f([1.1], [2.2, 3.3])}.to raise_error(ArgumentError)
  end

  # Subtraction
  it 'should subtract vectors of Fixnums' do
    expect(Ryeppp.subtract_v64sv64s_v64s([1], [2])).to eq([-1])
    expect{Ryeppp.subtract_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.subtract_v64sv64s_v64s([SMALLEST_TOO_BIG_INTEGER], [2])}.to raise_error(RangeError)
    expect{Ryeppp.subtract_v64sv64s_v64s([BIGGEST_TOO_SMALL_INTEGER], [2])}.to raise_error(RangeError)
    expect{Ryeppp.subtract_v64sv64s_v64s([1], [2, 3])}.to raise_error(ArgumentError)
  end
  it 'should subtract vectors of Floats' do
    expect(Ryeppp.subtract_v64fv64f_v64f([1.1], [1.1])).to eq([0])
    expect{Ryeppp.subtract_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.subtract_v64fv64f_v64f([1.1], [2.2, 3.3])}.to raise_error(ArgumentError)
  end

  # Multiplication
  it 'should multiply a vector of Fixnums by a constant' do
    expect(Ryeppp.multiply_v64ss64s_v64s([1, 2, 3], 2)).to eq([2, 4, 6])
    expect{Ryeppp.multiply_v64ss64s_v64s([1, 'a'], 2)}.to raise_error(TypeError)
    expect{Ryeppp.multiply_v64ss64s_v64s([SMALLEST_TOO_BIG_INTEGER], 2)}.to raise_error(RangeError)
    expect{Ryeppp.multiply_v64ss64s_v64s([BIGGEST_TOO_SMALL_INTEGER], 2)}.to raise_error(RangeError)
    expect{Ryeppp.multiply_v64ss64s_v64s(2, 2)}.to raise_error(ArgumentError)
    expect{Ryeppp.multiply_v64ss64s_v64s([1, 2], 'a')}.to raise_error(ArgumentError)
  end
  it 'should multiply a vector of Floats by a constant' do
    expect(Ryeppp.multiply_v64fs64f_v64f([1.0, 2.0, 3.0], 2.0)).to eq([2.0, 4.0, 6.0])
    expect{Ryeppp.multiply_v64fs64f_v64f([1, 'a'], 2)}.to raise_error(TypeError)
    expect{Ryeppp.multiply_v64fs64f_v64f([1, 2], 'a')}.to raise_error(ArgumentError)
  end
  it 'should multiply vectors of Fixnums' do
    expect(Ryeppp.multiply_v64sv64s_v64s([2], [3])).to eq([6])
    expect{Ryeppp.multiply_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.multiply_v64sv64s_v64s([SMALLEST_TOO_BIG_INTEGER], [2])}.to raise_error(RangeError)
    expect{Ryeppp.multiply_v64sv64s_v64s([BIGGEST_TOO_SMALL_INTEGER], [2])}.to raise_error(RangeError)
    expect{Ryeppp.multiply_v64sv64s_v64s(2, [2])}.to raise_error(ArgumentError)
    expect{Ryeppp.multiply_v64sv64s_v64s([2], 2)}.to raise_error(ArgumentError)
    expect{Ryeppp.multiply_v64sv64s_v64s([1], [2, 3])}.to raise_error(ArgumentError)
  end
  it 'should multiply vectors of Floats' do
    expect(Ryeppp.multiply_v64fv64f_v64f([2.5], [3.5])).to eq([8.75])
    expect{Ryeppp.multiply_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.multiply_v64fv64f_v64f([1.1], [2.2, 3.3])}.to raise_error(ArgumentError)
  end

  # Dot Product
  it 'should do the dot product of vectors of Floats' do
    expect(Ryeppp.dotproduct_v64fv64f_s64f([1, 2, 3], [4, 5, 6])).to eq(32.0)
    expect{Ryeppp.dotproduct_v64fv64f_s64f([1, 2, 'a'], [4, 5, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.dotproduct_v64fv64f_s64f(2, [2])}.to raise_error(ArgumentError)
    expect{Ryeppp.dotproduct_v64fv64f_s64f([2], 2)}.to raise_error(ArgumentError)
    expect{Ryeppp.dotproduct_v64fv64f_s64f([1], [2, 3])}.to raise_error(ArgumentError)
  end

  # Minimum
  it 'should find the minimum in a vector of Fixnums' do
    expect(Ryeppp.min_v64s_s64s([3, 2, 1])).to eq(1)
    expect{Ryeppp.min_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.min_v64s_s64s([SMALLEST_TOO_BIG_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.min_v64s_s64s([BIGGEST_TOO_SMALL_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.min_v64s_s64s(2)}.to raise_error(ArgumentError)
  end
  it 'should find the minimum in a vector of Floats' do
    expect(Ryeppp.min_v64f_s64f([1.0, 2.0, 3.0])).to eq(1.0)
    expect{Ryeppp.min_v64f_s64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.min_v64f_s64f(1.0)}.to raise_error(ArgumentError)
  end

  # Maximum
  it 'should find the maximum in a vector of Fixnums' do
    expect(Ryeppp.max_v64s_s64s([3, 2, 1])).to eq(3)
    expect{Ryeppp.max_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.max_v64s_s64s([SMALLEST_TOO_BIG_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.max_v64s_s64s([BIGGEST_TOO_SMALL_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.max_v64s_s64s(2)}.to raise_error(ArgumentError)
  end
  it 'should find the maximum in a vector of Floats' do
    expect(Ryeppp.max_v64f_s64f([1.0, 2.0, 3.0])).to eq(3.0)
    expect{Ryeppp.max_v64f_s64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.max_v64f_s64f(1.0)}.to raise_error(ArgumentError)
  end

  # Pairwise Minima
  it 'should find the pairwise minima in vectors of Floats' do
    expect(Ryeppp.min_v64fv64f_v64f([1.0, 2.0, 3.0], [3.0, 2.0, 1.0])).to eq([1.0, 2.0, 1.0])
    expect{Ryeppp.min_v64fv64f_v64f([1.0, 'a'], [2.0, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.min_v64fv64f_v64f(1.0, [2.0, 'b'])}.to raise_error(ArgumentError)
    expect{Ryeppp.min_v64fv64f_v64f([1.0], 1)}.to raise_error(ArgumentError)
    expect{Ryeppp.min_v64fv64f_v64f([1.0], [2.0, 3.0])}.to raise_error(ArgumentError)
  end
  # Pairwise Maxima
  it 'should find the pairwise maxima in vectors of Floats' do
    expect(Ryeppp.max_v64fv64f_v64f([1.0, 2.0, 3.0], [3.0, 2.0, 1.0])).to eq([3.0, 2.0, 3.0])
    expect{Ryeppp.max_v64fv64f_v64f([1.0, 'a'], [2.0, 'b'])}.to raise_error(TypeError)
    expect{Ryeppp.max_v64fv64f_v64f(1.0, [2.0, 'b'])}.to raise_error(ArgumentError)
    expect{Ryeppp.max_v64fv64f_v64f([1.0, 'a'], 2.0)}.to raise_error(ArgumentError)
    expect{Ryeppp.max_v64fv64f_v64f([1.0], [2.0, 3.0])}.to raise_error(ArgumentError)
  end

  # Constant Minima
  it 'should find the minima in a vector of Floats and a constant' do
    expect(Ryeppp.min_v64fs64f_v64f([1.0, 2.0, 3.0], 2.0)).to eq([1.0, 2.0, 2.0])
    expect{Ryeppp.min_v64fs64f_v64f([1.0, 'a'], 2.0)}.to raise_error(TypeError)
    expect{Ryeppp.min_v64fs64f_v64f(1.0, 2.0)}.to raise_error(ArgumentError)
    expect{Ryeppp.min_v64fs64f_v64f([1.0], 'a')}.to raise_error(ArgumentError)
  end
  # Constant Maxima
  it 'should find the maxima in a vector of Floats and a constant' do
    expect(Ryeppp.max_v64fs64f_v64f([1.0, 2.0, 3.0], 2.5)).to eq([2.5, 2.5, 3.0])
    expect{Ryeppp.max_v64fs64f_v64f([1.0, 'a'], 2.5)}.to raise_error(TypeError)
    expect{Ryeppp.max_v64fs64f_v64f(1.0, 2.5)}.to raise_error(ArgumentError)
    expect{Ryeppp.max_v64fs64f_v64f([1.0, 'a'], 'a')}.to raise_error(ArgumentError)
  end

  # Negation
  it 'should negate vectors of Fixnums' do
    expect(Ryeppp.negate_v64s_s64s([1])).to eq([-1])
    expect{Ryeppp.negate_v64s_s64s([1, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.negate_v64s_s64s([SMALLEST_TOO_BIG_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.negate_v64s_s64s([BIGGEST_TOO_SMALL_INTEGER])}.to raise_error(RangeError)
    expect{Ryeppp.negate_v64s_s64s(1)}.to raise_error(ArgumentError)
  end
  it 'should negate vectors of Floats' do
    expect(Ryeppp.negate_v64f_s64f([1.1])).to eq([-1.1])
    expect{Ryeppp.negate_v64f_s64f([1.1, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.negate_v64f_s64f(1.1)}.to raise_error(ArgumentError)
  end

  # Sum
  it 'should sum a vector of Floats' do
    expect(Ryeppp.sum_v64f_s64f([1, 2, 3])).to eq(6.0)
    expect{Ryeppp.sum_v64f_s64f([1, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.sum_v64f_s64f(1)}.to raise_error(ArgumentError)
  end
  # Sum Absolute Values
  it 'should sum absolute values of a vector of Floats' do
    expect(Ryeppp.sumabs_v64f_s64f([1.0, -1.0, 2.0])).to eq(4.0)
    expect{Ryeppp.sumabs_v64f_s64f([1.0, -1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.sumabs_v64f_s64f(1.0)}.to raise_error(ArgumentError)
  end
  # Sum Square Values
  it 'should sum square values of a vector of Floats' do
    expect(Ryeppp.sumsquares_v64f_s64f([1.0, -1.0, 2.0])).to eq(6.0)
    expect{Ryeppp.sumsquares_v64f_s64f([1.0, -1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.sumsquares_v64f_s64f(1.0)}.to raise_error(ArgumentError)
  end

  # Log
  it 'should find the natural logarithm of elements of a vector of Floats' do
    expect(Ryeppp.log_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}).to eq([0.0, 0.69315, 1.09861])
    expect{Ryeppp.log_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.log_v64f_v64f(1.0)}.to raise_error(ArgumentError)
  end
  # Exp
  it 'should find the base e exponent of elements of a vector of Floats' do
    expect(Ryeppp.exp_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}).to eq([2.71828, 7.38906, 20.08554])
    expect{Ryeppp.exp_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.exp_v64f_v64f(1.0)}.to raise_error(ArgumentError)
  end
  # Sin
  it 'should find the sine of elements of a vector of Floats' do
    expect(Ryeppp.sin_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}).to eq([0.84147, 0.9093, 0.14112])
    expect{Ryeppp.sin_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.sin_v64f_v64f(1.0)}.to raise_error(ArgumentError)
  end
  # Cos
  it 'should find the cosine of elements of a vector of Floats' do
    expect(Ryeppp.cos_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}).to eq([0.5403, -0.41615, -0.98999])
    expect{Ryeppp.cos_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.cos_v64f_v64f(1.0)}.to raise_error(ArgumentError)
  end
  # Tan
  it 'should find the tangent of elements of a vector of Floats' do
    expect(Ryeppp.tan_v64f_v64f([1.0, 2.0, 3.0]).map{|o| o.round(5)}).to eq([1.55741, -2.18504, -0.14255])
    expect{Ryeppp.tan_v64f_v64f([1.0, 'a'])}.to raise_error(TypeError)
    expect{Ryeppp.tan_v64f_v64f(1.0)}.to raise_error(ArgumentError)
  end

  # Polynomial
  it 'should evaluate a polynomial for a vector of Floats' do
    # x^2 + x + 1
    # evaluated at x=1.
    expect(Ryeppp.evaluatepolynomial_v64fv64f_v64f([1.0, 1.0, 1.0], [1.0])).to eq([3.0])
    # -5x^3 - 4x^2 + 2x + 1
    # evaluated at x=0, x=1, and x=2.
    expect(Ryeppp.evaluatepolynomial_v64fv64f_v64f([-5, -4, 2, 1], [0, 1, 2])).to eq([1.0, -6.0, -51.0])
    expect{Ryeppp.evaluatepolynomial_v64fv64f_v64f([1, 'a'], [0, 1])}.to raise_error(TypeError)
    expect{Ryeppp.evaluatepolynomial_v64fv64f_v64f(1, [0, 1])}.to raise_error(ArgumentError)
    expect{Ryeppp.evaluatepolynomial_v64fv64f_v64f([1], 0)}.to raise_error(ArgumentError)
  end
end
