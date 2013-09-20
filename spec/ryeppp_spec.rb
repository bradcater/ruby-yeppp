require 'spec_helper'

describe Ryeppp do
  it 'should add vectors of Fixnums' do
    Ryeppp.add_v64sv64s_v64s([1], [2]).should eq([3])
  end
  it 'should add vectors of Floats' do
    Ryeppp.add_v64fv64f_v64f([1.1], [1.1]).should eq([2.2])
  end
  #it 'should do dot_products' do
  #  [1, 2, 3].c_dot_product([4, 5, 6]).should eq(32)
  #  expect{[1, 'b', 3].c_dot_product([4, 5, 6])}.to raise_error(TypeError)
  #  expect{[1, 2, 3].c_dot_product([4, 'e', 6])}.to raise_error(TypeError)
  #end
  #it 'should do euclidean_distance' do
  #  [1, 2].c_euclidean_distance([3, 4]).should eq(2 * Math.sqrt(2))
  #  expect{[1, 'b', 3].c_euclidean_distance([3, 4])}.to raise_error(TypeError)
  #  expect{[1, 2, 3].c_euclidean_distance([3, 'd'])}.to raise_error(TypeError)
  #end
  #it 'should do c_int_include' do
  #  [1, 2, 3].c_int_include?(1).should be true
  #  [1, 2, 3].c_int_include?(0).should be false
  #  expect{[1, 'b', 3].c_int_include?(1)}.to_not raise_error
  #  expect{[0, 'b', 3].c_int_include?(1)}.to raise_error(TypeError)
  #  expect{[1, 2, 3].c_int_include?('a')}.to raise_error(TypeError)
  #  expect{[0, 'b', 3].c_int_include?('a')}.to raise_error(TypeError)
  #end
  #it 'should do c_int_uniq' do
  #  [].c_int_uniq.should eq([])
  #  [1, 2, 3, 2, 1].c_int_uniq.sort.should eq([1, 2, 3])
  #  expect{[1, 'b', 3].c_int_uniq}.to raise_error(TypeError)
  #end
  #it 'should do c_magnitude' do
  #  [1, 2, 3].c_magnitude.should eq(Math.sqrt(14))
  #  expect{[1, 'b', 3].c_magnitude}.to raise_error(TypeError)
  #end
  #it 'should do c_mean' do
  #  [1, 2, 3].c_mean.should eq(2)
  #  expect{[1, 'b', 3].c_mean}.to raise_error(TypeError)
  #end
  #it 'should do c_pearson_correlation' do
  #  [1, 2, 3].c_pearson_correlation([4, 5, 6]).should eq(1)
  #  expect{[1, 'b', 3].c_pearson_correlation([4, 5, 6])}.to raise_error(TypeError)
  #  expect{[1, 2, 3].c_pearson_correlation([4, 'e', 6])}.to raise_error(TypeError)
  #end
  #it 'should do c_variance' do
  #  [1, 2, 3].c_variance.should eq(2.0 / 3.0)
  #  expect{[1, 'b', 3].c_variance}.to raise_error(TypeError)
  #end
end
