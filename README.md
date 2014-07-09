# Ryeppp

This gem provides bindings to the [Yeppp!](http://www.yeppp.info/) library.
According to the documentation, "Yeppp! is a high-performance SIMD-optimized
mathematical library for x86, ARM, and MIPS processors on Windows, Android, Mac
OS X, and GNU/Linux systems."

## Installation

Add this line to your application's Gemfile:

    gem 'ryeppp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ryeppp

You'll also need to [download](http://www.yeppp.info/downloads.html) the Yeppp!
library and unpack it in $HOME.

## Usage

The Ryeppp gem provides a single class `Ryeppp` with the following methods:

* `add_v64fv64f_v64f` - pairwise add 2 vectors of floats

* `add_v64sv64s_v64s` - pairwise add 2 vectors of integers

* `subtract_v64fv64f_v64f` - pairwise subtract 2 vectors of floats

* `subtract_v64sv64s_v64s` - pairwise subtract 2 vectors of integers

* `multiply_v64fs64f_v64f` - multiply a vector of floats by a float

* `multiply_v64sv64s_v64s` - multiply a vector of integers by an integer

* `multiply_v64fv64f_v64f` - pairwise multiply 2 vectors of floats

* `multiply_v64ss64s_v64s` - pairwise multiply 2 vectors of integers

* `dotproduct_v64fv64f_s64f` - compute the dot product of 2 vectors of floats

* `min_v64f_s64f` - find the minimum in a vector of floats

* `min_v64s_s64s` - find the minimum in a vector of integers

* `max_v64f_s64f` - find the maximum in a vector of floats

* `max_v64s_s64s` - find the maximum in a vector of integers

* `min_v64fv64f_v64f` - find the pairwise minimum in 2 vectors of floats

* `max_v64fv64f_v64f` - find the pairwise maximum in 2 vectors of floats

* `min_v64fs64f_v64f` - find the pairwise minimum of a vector of floats and a
  constant

* `max_v64fs64f_v64f` - find the pairwise maximum of a vector of floats and a
  constant

* `negate_v64f_s64f` - negate a vector of floats

* `negate_v64s_s64s` - negate a vector of integers

* `sum_v64f_s64f` - compute the sum of a vector of floats

* `sumabs_v64f_s64f` - compute the sum of the absolute values of a vector of
  floats

* `sumsquares_v64f_s64f` - compute the sum of the squares of the values of a
  vector of floats

* `log_v64f_v64f` - compute the natural logarithm of the values of a vector of
  floats

* `exp_v64f_v64f` - compute the base-_e_ exponent of the values of a vector of
  floats

* `sin_v64f_v64f` - compute the sine of the values of a vector of floats

* `cos_v64f_v64f` - compute the cosine of the values of a vector of floats

* `tan_v64f_v64f` - compute the tangent of the values of a vector of floats

* `evaluatepolynomial_v64fv64f_v64f` - evaluate the polynomial with the given
  float coefficients in standard form at the given _x_-values

## Benchmarks

Since Yeppp! depends on your processor, using the library may or may not
provide performance improvements, so it's important to benchmark your code on
your own processor. A few [benchmarks](http://www.yeppp.info/benchmarks.html)
are provided, and the [examples](http://docs.yeppp.info/c/examples.html) also
provide performance comparisons.

To run the benchmarks, simply run

    $ ruby lib/ryeppp/bench.rb

## TODO

Add more benchmarks.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
