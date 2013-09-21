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

  # Sum
  it 'should sum a vector' do
    Ryeppp.sum_v64f_s64f([1, 2, 3]).should eq(6.0)
    expect{Ryeppp.sum_v64f_s64f([1, 'a'])}.to raise_error(TypeError)
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
end
