HEADERS = %{
// Include the Ruby headers and goodies
#include "ruby.h"

#include "stdio.h"
#include "assert.h"

#include "yepCore.h"
#include "yepLibrary.h"
}.strip.freeze

PRIMARY = %{
// Defining a space for information and references about the module to be stored internally
VALUE cRyeppp;
}.strip.freeze

# op_name is in [Sum, nil]
# verb_name is in [Add, Subtract]
FUNCS = Proc.new do |op_name, verb_name|
%{
  #{if op_name
    %{
    // #{op_name} an Array.
    static VALUE #{op_name.downcase}_v64f_s64f(VALUE self, VALUE x) {
      enum YepStatus status;
      long i;
      VALUE *x_a = RARRAY_PTR(x);
      long l = RARRAY_LEN(x);
      Yep64f *yep_x = (Yep64f*)calloc(l, sizeof(Yep64f));
      Yep64f sum;
    
      /* Allocate arrays of inputs and outputs */
      assert(yep_x != NULL);
    
      /* Initialize the Yeppp! library */
      status = yepLibrary_Init();
      assert(status == YepStatusOk);
    
      /* Load x_a into yep_x. */
      for (i=0; i<l; i++) {
        if (TYPE(x_a[i]) != T_FIXNUM) {
          rb_raise(rb_eTypeError, "input was not all integers");
        }
        yep_x[i] = (Yep64f)NUM2DBL(x_a[i]);
      }
    
      /* Perform the addition */
      status = yepCore_#{op_name}_V64f_S64f(yep_x, &sum, (YepSize)l);
      assert(status == YepStatusOk);
    
      /* Deinitialize the Yeppp! library */
      status = yepLibrary_Release();
      assert(status == YepStatusOk);
    
      /* Release the memory allocated for arrays */
      free(yep_x);
      return DBL2NUM((double)sum);
    }
    }.strip
  end}

  #{[
    ['s', 'long', 'INT', 'T_FIXNUM', 'integers'],
    ['f', 'double', 'DBL', 'T_FLOAT', 'floats']
  ].map do |(type, c_type, ruby_type, ruby_klass, ruby_klass_human)|
    %{
      // #{verb_name} Arrays of Fixnums.
      static VALUE #{verb_name.downcase}_v64#{type}v64#{type}_v64#{type}(VALUE self, VALUE x, VALUE y) {
        enum YepStatus status;
        VALUE new_ary;
        long i;
        VALUE *x_a = RARRAY_PTR(x);
        VALUE *y_a = RARRAY_PTR(y);
        long l = RARRAY_LEN(x);
        Yep64#{type} *yep_x = (Yep64#{type}*)calloc(l, sizeof(Yep64#{type}));
        Yep64#{type} *yep_y = (Yep64#{type}*)calloc(l, sizeof(Yep64#{type}));
        Yep64#{type} *yep_z = (Yep64#{type}*)calloc(l, sizeof(Yep64#{type}));
      
        /* Allocate arrays of inputs and outputs */
        assert(yep_x != NULL);
        assert(yep_y != NULL);
        assert(yep_z != NULL);
      
        /* Initialize the Yeppp! library */
        status = yepLibrary_Init();
        assert(status == YepStatusOk);
      
        /* Load x_a and y_a into yep_x and yep_y. */
        for (i=0; i<l; i++) {
          if (TYPE(x_a[i]) != #{ruby_klass}) {
            rb_raise(rb_eTypeError, "input was not all #{ruby_klass_human}");
          }
          yep_x[i] = (Yep64#{type})NUM2#{ruby_type}(x_a[i]);
          if (TYPE(y_a[i]) != #{ruby_klass}) {
            rb_raise(rb_eTypeError, "input was not all #{ruby_klass_human}");
          }
          yep_y[i] = (Yep64#{type})NUM2#{ruby_type}(y_a[i]);
        }
      
        /* Perform the addition */
        status = yepCore_#{verb_name}_V64#{type}V64#{type}_V64#{type}(yep_x, yep_y, yep_z, (YepSize)l);
        assert(status == YepStatusOk);
        new_ary = rb_ary_new2(l);
        for (i=0; i<l; i++) {
          rb_ary_push(new_ary, #{ruby_type}2NUM((#{c_type})yep_z[i]));
        }
      
        /* Deinitialize the Yeppp! library */
        status = yepLibrary_Release();
        assert(status == YepStatusOk);
      
        /* Release the memory allocated for arrays */
        free(yep_x);
        free(yep_y);
        free(yep_z);
        return new_ary;
      }
    }.strip
  end.join("\n\n")}
  }.strip
end

NEGATE = [
  ['s', 'long', 'INT', 'T_FIXNUM', 'integers'],
  ['f', 'double', 'DBL', 'T_FLOAT', 'floats']
].map do |(type, c_type, ruby_type, ruby_klass, ruby_klass_human)|
  %{
  // Negate an Array.
  static VALUE negate_v64#{type}_s64#{type}(VALUE self, VALUE x) {
    enum YepStatus status;
    long i;
    VALUE new_ary;
    VALUE *x_a = RARRAY_PTR(x);
    long l = RARRAY_LEN(x);
  
    /* Allocate arrays of inputs and outputs */
    Yep64#{type} *yep_x = (Yep64#{type}*)calloc(l, sizeof(Yep64#{type}));
    Yep64#{type} *yep_y = (Yep64#{type}*)calloc(l, sizeof(Yep64#{type}));
    assert(yep_x != NULL);
    assert(yep_y != NULL);
  
    /* Initialize the Yeppp! library */
    status = yepLibrary_Init();
    assert(status == YepStatusOk);
  
    /* Load x_a into yep_x */
    for (i=0; i<l; i++) {
      if (TYPE(x_a[i]) != #{ruby_klass}) {
        rb_raise(rb_eTypeError, "input was not all #{ruby_klass_human}");
      }
      yep_x[i] = (Yep64#{type})NUM2#{ruby_type}(x_a[i]);
    }
  
    /* Perform the negation */
    status = yepCore_Negate_V64#{type}_V64#{type}(yep_x, yep_y, (YepSize)l);
    assert(status == YepStatusOk);
  
    /* Create the new Ruby Array */
    new_ary = rb_ary_new2(l);
    for (i=0; i<l; i++) {
      rb_ary_push(new_ary, #{ruby_type}2NUM((#{c_type})yep_y[i]));
    }
  
    /* Deinitialize the Yeppp! library */
    status = yepLibrary_Release();
    assert(status == YepStatusOk);
  
    /* Release the memory allocated for arrays */
    free(yep_x);
    free(yep_y);
   
    return new_ary;
  }
  }.strip
end.join("\n\n")

INITIALIZER = %{
// The initialization method for this module
void Init_ryeppp() {
  cRyeppp = rb_define_class("Ryeppp", rb_cObject);
  rb_define_singleton_method(cRyeppp, "sum_v64f_s64f", sum_v64f_s64f, 1);
  rb_define_singleton_method(cRyeppp, "add_v64sv64s_v64s", add_v64sv64s_v64s, 2);
  rb_define_singleton_method(cRyeppp, "add_v64fv64f_v64f", add_v64fv64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "subtract_v64sv64s_v64s", subtract_v64sv64s_v64s, 2);
  rb_define_singleton_method(cRyeppp, "subtract_v64fv64f_v64f", subtract_v64fv64f_v64f, 2);
  rb_define_singleton_method(cRyeppp, "negate_v64s_s64s", negate_v64s_s64s, 1);
  rb_define_singleton_method(cRyeppp, "negate_v64f_s64f", negate_v64f_s64f, 1);
}
}.strip.freeze
