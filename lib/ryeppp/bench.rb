require 'benchmark'
require 'inline'

$:<< './lib'
require 'ryeppp'

VERBOSE = %w{1 t true y yes}.include?(ENV['VERBOSE'])

def puts_with_pounds(s)
  puts "\n\n#{s} #{'#' * (79 - s.size)}"
end

class Array
  def sum
    self.inject(0){|sum, o| sum + o}
  end
  def sumabs
    self.inject(0){|sum, o| sum + o.abs}
  end
  def sumsquares
    self.inject(0){|sum, o| sum + o**2}
  end
  inline do |builder|
    builder.c %{
      static VALUE c_sum() {
        long n = RARRAY_LEN(self);
        double sum = 0.0;
      
        VALUE *x_a = RARRAY_PTR(self);
      
        long i;
        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          sum += NUM2DBL(x_a[i]);
        }
        return DBL2NUM(sum);
      }
    }
  end
  inline do |builder|
    builder.c %{
      static VALUE c_sumabs() {
        long n = RARRAY_LEN(self);
        double sum = 0.0;
      
        VALUE *x_a = RARRAY_PTR(self);
      
        long i;
        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          sum += (NUM2DBL(x_a[i]) < 0) ? (-1.0 * NUM2DBL(x_a[i])) : NUM2DBL(x_a[i]);
        }
        return DBL2NUM(sum);
      }
    }
  end
  inline do |builder|
    builder.c %{
      static VALUE c_sumsquares() {
        long n = RARRAY_LEN(self);
        double sum = 0.0;
      
        VALUE *x_a = RARRAY_PTR(self);
      
        long i;
        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          sum += NUM2DBL(x_a[i]) * NUM2DBL(x_a[i]);
        }
        return DBL2NUM(sum);
      }
    }
  end

  def dot_product_f(v2)
    self.each.with_index.inject(0) do |sum, (o, idx)|
      sum + o.to_f * v2[idx]
    end
  end
  inline do |builder|
    builder.c %{
      static VALUE c_dot_product_f(VALUE v2) {
        long n;
        double sum = 0.0;
        VALUE *x_a;
        VALUE *y_a;
        long i;

        if (TYPE(v2) != T_ARRAY) {
          rb_raise(rb_eTypeError, "first argument was not an Array");
        }

        x_a = RARRAY_PTR(self);
        y_a = RARRAY_PTR(v2);
        n = RARRAY_LEN(self);

        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          if (TYPE(y_a[i]) != T_FIXNUM && TYPE(y_a[i]) != T_BIGNUM && TYPE(y_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          sum += NUM2DBL(x_a[i]) * NUM2DBL(y_a[i]);
        }
        return DBL2NUM(sum);
      }
    }
  end

  def evaluate_polynomial(x)
    if self.size == 1
      self.first
    else
      self.last + x * self[0..-2].evaluate_polynomial(x)
    end
  end
  def evaluate_polynomial_iter(x)
    self.map.with_index do |o, i|
      self[i] * x ** (self.size - 1 - i)
    end.sum
  end
  inline do |builder|
    builder.prefix %{
      static inline double heron_evaluate(VALUE *x_a, long i, double x) {
        if (i == 0) {
          return NUM2DBL(x_a[i]);
        } else {
          return NUM2DBL(x_a[i]) + x * heron_evaluate(x_a, i - 1, x);
        }
      }
    }
    builder.c %{
      static VALUE c_evaluate_polynomial(VALUE x_v) {
        long n;
        VALUE *x_a;
        double x;
        long i;

        if (TYPE(x_v) != T_FIXNUM && TYPE(x_v) != T_BIGNUM && TYPE(x_v) != T_FLOAT) {
          rb_raise(rb_eTypeError, "first argument was not an integer or float");
        }
      
        x_a = RARRAY_PTR(self);
        n = RARRAY_LEN(self);
        x = NUM2DBL(x_v);

        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
        }
        return DBL2NUM(heron_evaluate(x_a, n - 1, x));
      }
    }
  end
  inline do |builder|
    builder.include('<math.h>')
    builder.c %{
      static VALUE c_evaluate_polynomial_iter(VALUE x_v) {
        long n;
        VALUE *x_a;
        double x;
        double res;
        long i;

        if (TYPE(x_v) != T_FIXNUM && TYPE(x_v) != T_BIGNUM && TYPE(x_v) != T_FLOAT) {
          rb_raise(rb_eTypeError, "first argument was not an integer or float");
        }

        x_a = RARRAY_PTR(self);
        n = RARRAY_LEN(self);
        x = NUM2DBL(x_v);
        res = 0;

        for (i=0; i<n; i++) {
          if (TYPE(x_a[i]) != T_FIXNUM && TYPE(x_a[i]) != T_BIGNUM && TYPE(x_a[i]) != T_FLOAT) {
            rb_raise(rb_eTypeError, "input was not all integers and floats");
          }
          res += NUM2DBL(x_a[i]) * pow(x, (n - 1 - i));
        }
        return DBL2NUM(res);
      }
    }
  end
end

WIDTH = 40
V_f = (0..1_024*1_024).to_a.map{Random.rand}

# Dot Product
puts_with_pounds "Dot Product"
n = 1
if VERBOSE
  puts "dot_product_f: #{V_f.dot_product_f(V_f)}"
  puts "c_dot_product_f: #{V_f.c_dot_product_f(V_f)}"
  puts "Ryeppp.dotproduct_v64fv64f_s64f: #{Ryeppp.dotproduct_v64fv64f_s64f(V_f, V_f)}"
end
Benchmark.bm(WIDTH) do |x|
  x.report("dot_product_f:")                   { n.times { V_f.dot_product_f(V_f) } }
  x.report("c_dot_product_f:")                 { n.times { V_f.c_dot_product_f(V_f) } }
  x.report("Ryeppp.dotproduct_v64fv64f_s64f:") { n.times { Ryeppp.dotproduct_v64fv64f_s64f(V_f, V_f) } }
end

# Sums
puts_with_pounds "Sums"
n = 1
Benchmark.bm(WIDTH) do |x|
  ['', 'abs', 'squares'].each do |suffix|
    x.report("sum#{suffix}:")                  { n.times { V_f.send("sum#{suffix}") } }
    x.report("c_sum#{suffix}:")                { n.times { V_f.send("c_sum#{suffix}") } }
    x.report("Ryeppp.sum#{suffix}_v64f_s64f:") { n.times { Ryeppp.send("sum#{suffix}_v64f_s64f", V_f) } }
  end
end

# Math Functions
puts_with_pounds "Math Functions"
n = 1
Benchmark.bm(WIDTH) do |x|
  %w{log exp sin cos tan}.each do |f|
    x.report("#{f}:")                  { n.times { V_f.each{|o| Math.send(f, o)} } }
    x.report("Ryeppp.#{f}_v64f_v64f:") { n.times { Ryeppp.send("#{f}_v64f_v64f", V_f) } }
  end
end

# Polynomial
puts_with_pounds "Polynomial"
n = 1
P_SMALL = (0..1_024).to_a.map{Random.rand}
P_LARGE = (0..1_024*1_024).to_a.map{Random.rand}
X = Random.rand
if VERBOSE
  puts "evaluate_polynomial: #{P_SMALL.evaluate_polynomial(X)}"
  puts "evaluate_polynomial_iter: #{P_SMALL.evaluate_polynomial_iter(X)}"
  puts "c_evaluate_polynomial: #{P_SMALL.c_evaluate_polynomial(X)}"
  puts "c_evaluate_polynomial_iter: #{P_SMALL.c_evaluate_polynomial_iter(X)}"
  puts "Ryeppp.evaluatepolynomial_v64fv64f_v64f: #{Ryeppp.evaluatepolynomial_v64fv64f_v64f(P_SMALL, [X])}"
  puts "evaluate_polynomial_iter: #{P_LARGE.evaluate_polynomial_iter(X)}"
  puts "c_evaluate_polynomial_iter: #{P_LARGE.c_evaluate_polynomial_iter(X)}"
  puts "Ryeppp.evaluatepolynomial_v64fv64f_v64f: #{Ryeppp.evaluatepolynomial_v64fv64f_v64f(P_LARGE, [X])}"
end
Benchmark.bm(WIDTH) do |x|
  x.report("evaluate_polynomial:")                     { n.times { P_SMALL.evaluate_polynomial(X) } }
  x.report("c_evaluate_polynomial:")                   { n.times { P_SMALL.c_evaluate_polynomial(X) } }
  x.report("Ryeppp.evaluatepolynomial_v64fv64f_v64f:") { n.times { Ryeppp.evaluatepolynomial_v64fv64f_v64f(P_SMALL, [X]) } }
  x.report("evaluate_polynomial_iter:")                { n.times { P_LARGE.evaluate_polynomial_iter(X) } }
  x.report("c_evaluate_polynomial_iter:")              { n.times { P_LARGE.c_evaluate_polynomial_iter(X) } }
  x.report("Ryeppp.evaluatepolynomial_v64fv64f_v64f:") { n.times { Ryeppp.evaluatepolynomial_v64fv64f_v64f(P_LARGE, [X]) } }
end
