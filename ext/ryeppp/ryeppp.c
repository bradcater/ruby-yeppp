// Include the Ruby headers and goodies
#include "ruby.h"

#include "stdio.h"
#include "assert.h"

#include "yepCore.h"
#include "yepLibrary.h"

// Defining a space for information and references about the module to be stored internally
VALUE cRyeppp;

// Add Arrays of Fixnums.
static VALUE add_v64sv64s_v64s(VALUE self, VALUE x, VALUE y) {
  enum YepStatus status;
  VALUE new_ary;
  long i;
  VALUE *x_a = RARRAY_PTR(x);
  VALUE *y_a = RARRAY_PTR(y);
  long l = RARRAY_LEN(x);
	Yep64s *yep_x = (Yep64s*)calloc(l, sizeof(Yep64s));
	Yep64s *yep_y = (Yep64s*)calloc(l, sizeof(Yep64s));
	Yep64s *yep_z = (Yep64s*)calloc(l, sizeof(Yep64s));

	/* Allocate arrays of inputs and outputs */
	assert(yep_x != NULL);
	assert(yep_y != NULL);
	assert(yep_z != NULL);

	/* Initialize the Yeppp! library */
	status = yepLibrary_Init();
	assert(status == YepStatusOk);

  /* Load x_a and y_a into yep_x and yep_y. */
  for (i=0; i<l; i++) {
    if (TYPE(x_a[i]) != T_FIXNUM) {
      rb_raise(rb_eTypeError, "input was not all integers");
    }
    yep_x[i] = (Yep64s)NUM2INT(x_a[i]);
    if (TYPE(y_a[i]) != T_FIXNUM) {
      rb_raise(rb_eTypeError, "input was not all integers");
    }
    yep_y[i] = (Yep64s)NUM2INT(y_a[i]);
  }

  /* Perform the addition */
  status = yepCore_Add_V64sV64s_V64s(yep_x, yep_y, yep_z, (YepSize)l);
	assert(status == YepStatusOk);
  new_ary = rb_ary_new2(l);
  for (i=0; i<l; i++) {
    rb_ary_push(new_ary, INT2NUM((long)yep_z[i]));
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

// Add Arrays of Floats.
static VALUE add_v64fv64f_v64f(VALUE self, VALUE x, VALUE y) {
  enum YepStatus status;
  VALUE new_ary;
  long i;
  VALUE *x_a = RARRAY_PTR(x);
  VALUE *y_a = RARRAY_PTR(y);
  long l = RARRAY_LEN(x);
	Yep64f *yep_x = (Yep64f*)calloc(l, sizeof(Yep64f));
	Yep64f *yep_y = (Yep64f*)calloc(l, sizeof(Yep64f));
	Yep64f *yep_z = (Yep64f*)calloc(l, sizeof(Yep64f));

	/* Allocate arrays of inputs and outputs */
	assert(yep_x != NULL);
	assert(yep_y != NULL);
	assert(yep_z != NULL);

	/* Initialize the Yeppp! library */
	status = yepLibrary_Init();
	assert(status == YepStatusOk);

  /* Load x_a and y_a into yep_x and yep_y. */
  for (i=0; i<l; i++) {
    yep_x[i] = (Yep64f)NUM2DBL(x_a[i]);
    yep_y[i] = (Yep64f)NUM2DBL(y_a[i]);
  }

  /* Perform the addition */
  status = yepCore_Add_V64fV64f_V64f(yep_x, yep_y, yep_z, (YepSize)l);
	assert(status == YepStatusOk);
  new_ary = rb_ary_new2(l);
  for (i=0; i<l; i++) {
    rb_ary_push(new_ary, rb_float_new((double)yep_z[i]));
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

// The initialization method for this module
void Init_ryeppp() {
  cRyeppp = rb_define_class("Ryeppp", rb_cObject);
  rb_define_singleton_method(cRyeppp, "add_v64sv64s_v64s", add_v64sv64s_v64s, 2);
  rb_define_singleton_method(cRyeppp, "add_v64fv64f_v64f", add_v64fv64f_v64f, 2);
}
