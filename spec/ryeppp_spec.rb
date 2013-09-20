require 'spec_helper'

describe Ryeppp do
  it 'should add vectors of Fixnums' do
    Ryeppp.add_v64sv64s_v64s([1], [2]).should eq([3])
    expect{Ryeppp.add_v64sv64s_v64s([1, 'a'], [2, 'b'])}.to raise_error(TypeError)
  end
  it 'should add vectors of Floats' do
    Ryeppp.add_v64fv64f_v64f([1.1], [1.1]).should eq([2.2])
    expect{Ryeppp.add_v64fv64f_v64f([1.1, 'a'], [2.2, 'b'])}.to raise_error(TypeError)
  end
end
