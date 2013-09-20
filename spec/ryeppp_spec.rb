require 'spec_helper'

describe Ryeppp do
  # Addition
  it 'should sum a vector' do
    Ryeppp.sum_v64f_s64f([1, 2, 3]).should eq(6.0)
    expect{Ryeppp.sum_v64f_s64f([1, 'a'])}.to raise_error(TypeError)
  end
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
