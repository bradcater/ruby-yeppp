def allocate_yep64_typed_array_and_assert(var_names, len_var_name, opts={})
  var_names = Array(var_names)
  type = opts[:type] || '{{type}}'
  assert = opts[:assert].nil? ? true : opts[:assert]
  %{#{var_names.map{|vn| %{Yep64#{type} *yep_#{vn} = (Yep64#{type}*)calloc(#{len_var_name}, sizeof(Yep64#{type}));}}.join("\n")}
    #{assert ? var_names.map{|vn| %{assert(yep_#{vn} != NULL);}}.join("\n") : nil}}
end

def deinitialize_yeppp
  %{/* Deinitialize the Yeppp! library */
    status = yepLibrary_Release();
    assert(status == YepStatusOk);}
end

def initialize_yeppp
  %{/* Initialize the Yeppp! library */
    status = yepLibrary_Init();
    assert(status == YepStatusOk);}
end

def load_ruby_array_from_yeppp_array(var_name, iteration_var_name, len_var_name, type)
  %{/* Load the Ruby Array */
    new_ary = rb_ary_new2(#{len_var_name});
    for (#{iteration_var_name}=0; #{iteration_var_name}<#{len_var_name}; #{iteration_var_name}++) {
      rb_ary_push(new_ary, #{type == 'f' ? 'DBL' : 'INT'}2NUM((#{type == 'f' ? 'double' : 'long'})yep_#{var_name}[#{iteration_var_name}]));
    }}
end
def load_ruby_array_from_yeppp_array_parameterized(var_name, iteration_var_name, len_var_name)
  %{/* Load the Ruby Array */
    new_ary = rb_ary_new2(#{len_var_name});
    for (#{iteration_var_name}=0; #{iteration_var_name}<#{len_var_name}; #{iteration_var_name}++) {
      rb_ary_push(new_ary, {{ruby_type}}2NUM(({{c_type}})yep_#{var_name}[#{iteration_var_name}]));
    }}
end
def load_ruby_array_into_yeppp_array(var_name, iteration_var_name, len_var_name, type, permitted_types)
  pt = permitted_types.map do |t|
    case t
      when :float
        "TYPE(#{var_name}_a[#{iteration_var_name}]) != T_FLOAT"
      when :integer
        "TYPE(#{var_name}_a[#{iteration_var_name}]) != T_FIXNUM"
      else
        raise "Invalid permitted_type: #{t}."
    end
  end.join(' && ')
  %{/* Load #{var_name}_a into yep_#{var_name}. */
    for (#{iteration_var_name}=0; #{iteration_var_name}<#{len_var_name}; #{iteration_var_name}++) {
      if (#{pt}) {
        rb_raise(rb_eTypeError, "input was not all #{permitted_types.map(&:to_s).join(' and ')}");
      }
      yep_#{var_name}[#{iteration_var_name}] = (Yep64#{type})NUM2#{type == 'f' ? 'DBL' : 'INT'}(#{var_name}_a[#{iteration_var_name}]);
    }}
end
def load_ruby_array_into_yeppp_array_parameterized(var_name, iteration_var_name, len_var_name)
  %{/* Load #{var_name}_a into yep_#{var_name}. */
    for (#{iteration_var_name}=0; #{iteration_var_name}<#{len_var_name}; #{iteration_var_name}++) {
      if (TYPE(#{var_name}_a[#{iteration_var_name}]) != {{ruby_klass}}) {
        rb_raise(rb_eTypeError, "input was not all {{ruby_klass_human}}");
      }
      yep_#{var_name}[#{iteration_var_name}] = (Yep64{{type}})NUM2{{ruby_type}}(#{var_name}_a[#{iteration_var_name}]);
    }}
end

def release_array_memory(var_names)
  var_names = Array(var_names)
  %{/* Release the memory allocated for array#{var_names.size == 1 ? nil : 's'} */
    #{var_names.map{|vn| %{free(yep_#{vn});}}.join("\n")}}
end

def typed_variants(s, opts={})
  [
    ['s', 'long', 'INT', 'T_FIXNUM', 'integers'],
    ['f', 'double', 'DBL', 'T_FLOAT', 'floats']
  ].map do |(type, c_type, ruby_type, ruby_klass, ruby_klass_human)|
    if !opts[:only_type] || opts[:only_type] == type
      s.gsub(/{{type}}/, type)
       .gsub(/{{c_type}}/, c_type)
       .gsub(/{{ruby_type}}/, ruby_type)
       .gsub(/{{ruby_klass}}/, ruby_klass)
       .gsub(/{{ruby_klass_human}}/, ruby_klass_human)
    else
      ''
    end
  end.map(&:strip).join("\n\n")
end

HEADERS = %{
// Include the Ruby headers and goodies
#include "ruby.h"

#include "stdio.h"
#include "assert.h"

#include "yepCore.h"
#include "yepLibrary.h"
#include "yepMath.h"
}.strip.freeze

PRIMARY = %{
// Defining a space for information and references about the module to be stored
// internally
VALUE cRyeppp;
}.strip.freeze

# verb_name is in [Add, Subtract, Multiply]
FUNCS = Proc.new do |verb_name|
%{#{if verb_name == 'Multiply'
      typed_variants(%{
        static VALUE multiply_v64{{type}}s64{{type}}_v64{{type}}(VALUE self, VALUE x, VALUE multiply_by) {
          enum YepStatus status;
          long i;
          VALUE new_ary;
          VALUE *x_a = RARRAY_PTR(x);
          long l = RARRAY_LEN(x);
          Yep64{{type}} mult_by = (Yep64{{type}})NUM2DBL(multiply_by);
        
          /* Allocate arrays of inputs and outputs */
          #{allocate_yep64_typed_array_and_assert(%w{x y}, 'l')}
        
          #{initialize_yeppp}
        
          #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
        
          /* Perform the operation */
          status = yepCore_Multiply_V64{{type}}S64{{type}}_V64{{type}}(yep_x, mult_by, yep_y, (YepSize)l);
          assert(status == YepStatusOk);

          #{load_ruby_array_from_yeppp_array_parameterized('y', 'i', 'l')}
        
          #{deinitialize_yeppp}
          
          #{release_array_memory(%w{x y})}
          
          return new_ary;
        }
      }).strip.freeze
    end
  }

  #{typed_variants(%{
    // #{verb_name} Arrays of Fixnums.
    static VALUE #{verb_name.downcase}_v64{{type}}v64{{type}}_v64{{type}}(VALUE self, VALUE x, VALUE y) {
      enum YepStatus status;
      VALUE new_ary;
      long i;
      VALUE *x_a = RARRAY_PTR(x);
      VALUE *y_a = RARRAY_PTR(y);
      long l = RARRAY_LEN(x);
    
      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert(%w{x y z}, 'l')}

      #{initialize_yeppp}
    
      #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
      #{load_ruby_array_into_yeppp_array_parameterized('y', 'i', 'l')}
    
      /* Perform the addition */
      status = yepCore_#{verb_name}_V64{{type}}V64{{type}}_V64{{type}}(yep_x, yep_y, yep_z, (YepSize)l);
      assert(status == YepStatusOk);

      #{load_ruby_array_from_yeppp_array_parameterized('z', 'i', 'l')}
    
      #{deinitialize_yeppp}
    
      #{release_array_memory(%w{x y z})}

      return new_ary;
    }
  })}
}
end

DOT_PRODUCT = %{
  // Get the dot product of 2 Arrays.
  static VALUE dotproduct_v64fv64f_s64f(VALUE self, VALUE x, VALUE y) {
    enum YepStatus status;
    long i;
    Yep64f dp;
    VALUE *x_a = RARRAY_PTR(x);
    VALUE *y_a = RARRAY_PTR(y);
    long l = RARRAY_LEN(x);
  
    /* Allocate arrays of inputs and outputs */
    #{allocate_yep64_typed_array_and_assert(%w{x y}, 'l', :type => 'f')}

    #{initialize_yeppp}
  
    #{load_ruby_array_into_yeppp_array('x', 'i', 'l', 'f', [:integer, :float])}
    #{load_ruby_array_into_yeppp_array('y', 'i', 'l', 'f', [:integer, :float])}
  
    /* Perform the operation */
    status = yepCore_DotProduct_V64fV64f_S64f(yep_x, yep_y, &dp, (YepSize)l);
    assert(status == YepStatusOk);

    #{deinitialize_yeppp}
  
    #{release_array_memory(%w{x y})}
  
    return DBL2NUM((double)dp);
  }
}.strip

MIN_MAX = typed_variants(%w{Min Max}.map do |kind|
  %{
    // Get the #{kind.downcase} value from an Array.
    static VALUE #{kind.downcase}_v64{{type}}_s64{{type}}(VALUE self, VALUE x) {
      enum YepStatus status;
      long i;
      Yep64{{type}} #{kind.downcase};
      VALUE *x_a = RARRAY_PTR(x);
      long l = RARRAY_LEN(x);
  
      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert('x', 'l')}

      #{initialize_yeppp}
  
      #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
  
      /* Perform the operation */
      status = yepCore_#{kind}_V64{{type}}_S64{{type}}(yep_x, &#{kind.downcase}, (YepSize)l);
      assert(status == YepStatusOk);

      #{deinitialize_yeppp}
  
      #{release_array_memory(%w{x})}
   
      return {{ruby_type}}2NUM(({{c_type}})#{kind.downcase});
    }
  }.strip
end.join("\n\n"))

PAIRWISE_MIN_MAX = typed_variants(%w{Min Max}.map do |kind|
  %{
    // Get the pairwise #{kind.downcase}ima from Arrays.
    static VALUE #{kind.downcase}_v64{{type}}v64{{type}}_v64{{type}}(VALUE self, VALUE x, VALUE y) {
      enum YepStatus status;
      long i;
      VALUE new_ary;
      VALUE *x_a = RARRAY_PTR(x);
      VALUE *y_a = RARRAY_PTR(y);
      long l = RARRAY_LEN(x);
  
      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert(%w{x y z}, 'l')}

      #{initialize_yeppp}
  
      #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
      #{load_ruby_array_into_yeppp_array_parameterized('y', 'i', 'l')}
  
      /* Perform the operation */
      status = yepCore_#{kind}_V64{{type}}V64{{type}}_V64{{type}}(yep_x, yep_y, yep_z, (YepSize)l);
      assert(status == YepStatusOk);

      #{load_ruby_array_from_yeppp_array_parameterized('z', 'i', 'l')}

      #{deinitialize_yeppp}
  
      #{release_array_memory(%w{x y z})}
   
      return new_ary;
    }
  }.strip
end.join("\n\n"), :only_type => 'f')

CONSTANT_MIN_MAX = typed_variants(%w{Min Max}.map do |kind|
  %{
    // Get the #{kind.downcase}ima from an Array and a constant.
    static VALUE #{kind.downcase}_v64{{type}}s64{{type}}_v64{{type}}(VALUE self, VALUE x, VALUE c) {
      enum YepStatus status;
      long i;
      VALUE new_ary;
      VALUE *x_a = RARRAY_PTR(x);
      long l = RARRAY_LEN(x);
      Yep64f konst = (Yep64f)NUM2{{ruby_type}}(c);
  
      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert(%w{x y}, 'l')}

      #{initialize_yeppp}
  
      #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
  
      /* Perform the operation */
      status = yepCore_#{kind}_V64{{type}}S64{{type}}_V64{{type}}(yep_x, konst, yep_y, (YepSize)l);
      assert(status == YepStatusOk);

      #{load_ruby_array_from_yeppp_array_parameterized('y', 'i', 'l')}

      #{deinitialize_yeppp}
  
      #{release_array_memory(%w{x y})}
   
      return new_ary;
    }
  }.strip
end.join("\n\n"), :only_type => 'f')

NEGATE = typed_variants(%{
  // Negate an Array.
  static VALUE negate_v64{{type}}_s64{{type}}(VALUE self, VALUE x) {
    enum YepStatus status;
    long i;
    VALUE new_ary;
    VALUE *x_a = RARRAY_PTR(x);
    long l = RARRAY_LEN(x);
  
    /* Allocate arrays of inputs and outputs */
    #{allocate_yep64_typed_array_and_assert(%w{x y}, 'l')}
  
    #{initialize_yeppp}
  
    #{load_ruby_array_into_yeppp_array_parameterized('x', 'i', 'l')}
  
    /* Perform the negation */
    status = yepCore_Negate_V64{{type}}_V64{{type}}(yep_x, yep_y, (YepSize)l);
    assert(status == YepStatusOk);
  
    #{load_ruby_array_from_yeppp_array_parameterized('y', 'i', 'l')}
  
    #{deinitialize_yeppp}
  
    #{release_array_memory(%w{x y})}
   
    return new_ary;
  }
}).freeze

SUMS = %w{Sum SumAbs SumSquares}.map do |kind|
  %{
    static VALUE #{kind.downcase}_v64f_s64f(VALUE self, VALUE x) {
      enum YepStatus status;
      long i;
      Yep64f sum;
      long l = RARRAY_LEN(x);
      VALUE *x_a = RARRAY_PTR(x);

      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert('x', 'l', :type => 'f')}

      #{initialize_yeppp}

      #{load_ruby_array_into_yeppp_array('x', 'i', 'l', 'f', [:integer, :float])}

      /* Perform the operation */
      status = yepCore_#{kind}_V64f_S64f(yep_x, &sum, (YepSize)l);
      assert(status == YepStatusOk);

      #{deinitialize_yeppp}
    
      #{release_array_memory(%w{x})}

      return DBL2NUM((double)sum);
    }
  }.strip
end.join("\n\n").freeze

MATHS_KINDS = %w{Log Exp Sin Cos Tan}.freeze
MATHS = MATHS_KINDS.map do |kind|
  %{
    static VALUE #{kind.downcase}_v64f_v64f(VALUE self, VALUE x) {
      enum YepStatus status;
      long i;
      VALUE new_ary;
      long l = RARRAY_LEN(x);
      VALUE *x_a = RARRAY_PTR(x);

      /* Allocate arrays of inputs and outputs */
      #{allocate_yep64_typed_array_and_assert(%w{x y}, 'l', :type => 'f')}

      #{initialize_yeppp}

      #{load_ruby_array_into_yeppp_array('x', 'i', 'l', 'f', [:integer, :float])}

      /* Perform the operation */
      status = yepMath_#{kind}_V64f_V64f(yep_x, yep_y, (YepSize)l);
      assert(status == YepStatusOk);

      #{load_ruby_array_from_yeppp_array('y', 'i', 'l', 'f')}

      #{deinitialize_yeppp}
    
      #{release_array_memory(%w{x y})}

      return new_ary;
    }
  }.strip
end.join("\n\n").freeze

POLYNOMIAL = %{
  // x is the coefficients
  // where is the set of points at which to evaluate x
  static VALUE evaluatepolynomial_v64fv64f_v64f(VALUE self, VALUE x, VALUE where) {
    enum YepStatus status;
    long i;
    VALUE new_ary;
    long x_l = RARRAY_LEN(x);
    long y_l = RARRAY_LEN(where);
    VALUE *x_a = RARRAY_PTR(x);
    VALUE *y_a = RARRAY_PTR(where);

    /* Allocate arrays of inputs and outputs */
    #{allocate_yep64_typed_array_and_assert(%w{x}, 'x_l', :assert => false, :type => 'f')}
    #{allocate_yep64_typed_array_and_assert(%w{y z}, 'y_l', :assert => false, :type => 'f')}
    assert(yep_x != NULL);
    assert(yep_y != NULL);
    assert(yep_z != NULL);

    #{initialize_yeppp}

    #{load_ruby_array_into_yeppp_array('x', 'i', 'x_l', 'f', [:integer, :float])}
    #{load_ruby_array_into_yeppp_array('y', 'i', 'y_l', 'f', [:integer, :float])}

    /* Perform the operation */
    status = yepMath_EvaluatePolynomial_V64fV64f_V64f(yep_x, yep_y, yep_z, (YepSize)x_l, (YepSize)y_l);
    assert(status == YepStatusOk);

    #{load_ruby_array_from_yeppp_array('z', 'i', 'y_l', 'f')}

    #{deinitialize_yeppp}
  
    #{release_array_memory(%w{x y z})}
    
    return new_ary;
  }
}.strip.freeze

INITIALIZER = %{
// The initialization method for this module
void Init_ryeppp() {
  cRyeppp = rb_define_class("Ryeppp", rb_cObject);

  /* Addition */
  rb_define_singleton_method(cRyeppp, "add_v64fv64f_v64f", add_v64fv64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "add_v64sv64s_v64s", add_v64sv64s_v64s, 2);

  /* Subtraction */
  rb_define_singleton_method(cRyeppp, "subtract_v64fv64f_v64f", subtract_v64fv64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "subtract_v64sv64s_v64s", subtract_v64sv64s_v64s, 2);

  /* Multiplication */
  rb_define_singleton_method(cRyeppp, "multiply_v64fs64f_v64f", multiply_v64fs64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "multiply_v64sv64s_v64s", multiply_v64sv64s_v64s, 2);
  rb_define_singleton_method(cRyeppp, "multiply_v64fv64f_v64f", multiply_v64fv64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "multiply_v64ss64s_v64s", multiply_v64ss64s_v64s, 2);

  /* Dot Product */
  rb_define_singleton_method(cRyeppp, "dotproduct_v64fv64f_s64f", dotproduct_v64fv64f_s64f, 2);

  /* Minimum */
  rb_define_singleton_method(cRyeppp, "min_v64f_s64f", min_v64f_s64f, 1);
  rb_define_singleton_method(cRyeppp, "min_v64s_s64s", min_v64s_s64s, 1);

  /* Maximum */
  rb_define_singleton_method(cRyeppp, "max_v64f_s64f", max_v64f_s64f, 1);
  rb_define_singleton_method(cRyeppp, "max_v64s_s64s", max_v64s_s64s, 1);

  /* Pairwise Minima */
  rb_define_singleton_method(cRyeppp, "min_v64fv64f_v64f", min_v64fv64f_v64f, 2);
  // Pairwise signed min is not available.

  /* Pairwise Maxima */
  rb_define_singleton_method(cRyeppp, "max_v64fv64f_v64f", max_v64fv64f_v64f, 2);
  // Pairwise signed max is not available.

  /* Constant Minima */
  rb_define_singleton_method(cRyeppp, "min_v64fs64f_v64f", min_v64fs64f_v64f, 2);
  // Constant signed min is not available.

  /* Constant Maxima */
  rb_define_singleton_method(cRyeppp, "max_v64fs64f_v64f", max_v64fs64f_v64f, 2);
  // Constant signed max is not available.

  /* Negation */
  rb_define_singleton_method(cRyeppp, "negate_v64f_s64f", negate_v64f_s64f, 1);
  rb_define_singleton_method(cRyeppp, "negate_v64s_s64s", negate_v64s_s64s, 1);

  /* Sums */
  rb_define_singleton_method(cRyeppp, "sum_v64f_s64f", sum_v64f_s64f, 1);
  // Signed sum is not available.
  rb_define_singleton_method(cRyeppp, "sumabs_v64f_s64f", sumabs_v64f_s64f, 1);
  // Signed abs sum is not available.
  rb_define_singleton_method(cRyeppp, "sumsquares_v64f_s64f", sumsquares_v64f_s64f, 1);
  // Signed squares sum is not available.

  /* Maths */
  #{MATHS_KINDS.map do |kind|
    %{rb_define_singleton_method(cRyeppp, "#{kind.downcase}_v64f_v64f", #{kind.downcase}_v64f_v64f, 1);}
  end.join("\n")}

  /* Polynomial */
  rb_define_singleton_method(cRyeppp, "evaluatepolynomial_v64fv64f_v64f", evaluatepolynomial_v64fv64f_v64f, 2);
}
}.strip.freeze
