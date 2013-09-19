// Include the Ruby headers and goodies
#include "ruby.h"

#include "stdio.h"
#include "assert.h"
#include "yepLibrary.h"

// Defining a space for information and references about the module to be stored internally
VALUE cRyeppp;

static VALUE add_v8sv8s_v8s(VALUE self, VALUE x, VALUE y) {
  enum YepStatus status;
  VALUE new_ary;
  long i;
	/* Allocate arrays of inputs and outputs */
	printf("getting variables\n");
  long l = RARRAY_LEN(x);
	Yep64f *yep_x = (Yep64f*)calloc(l, sizeof(Yep64f));
	Yep64f *yep_y = (Yep64f*)calloc(l, sizeof(Yep64f));
	Yep64f *yep_z = (Yep64f*)calloc(l, sizeof(Yep64f));
	assert(yep_x != NULL);
	assert(yep_y != NULL);
	assert(yep_z != NULL);
  VALUE *x_a = RARRAY_PTR(x);
  VALUE *y_a = RARRAY_PTR(y);
	/* Initialize the Yeppp! library */
	printf("initializing\n");
	status = yepLibrary_Init();
	assert(status == YepStatusOk);
	/* Zero-initialize the output arrays */
	printf("zero-initializing\n");
	memset(yep_x, 0, l * sizeof(Yep64f));
	memset(yep_y, 0, l * sizeof(Yep64f));
  memset(yep_z, 0, l * sizeof(Yep64f));
  /* Load x_a and y_a into yep_x and yep_y. */
	printf("loading vars\n");
  for (i=0; i<l; i++) {
    printf("%.2f\n", NUM2DBL(x_a[i]));
    printf("%.2f\n", NUM2DBL(y_a[i]));
    yep_x[i] = (Yep64f)NUM2DBL(x_a[i]);
    yep_y[i] = (Yep64f)NUM2DBL(y_a[i]);
  }
  /* Perform the addition */
	printf("adding\n");
  status = yepCore_Add_V8sV8s_V8s(yep_x, yep_y, yep_z, (YepSize)l);
	assert(status == YepStatusOk);
  new_ary = rb_ary_new2(l);
  for (i=0; i<l; i++) {
    printf("%.2f\n", (double)yep_z[i]);
    rb_ary_push(new_ary, rb_float_new((double)yep_z[i]));
  }
	/* Deinitialize the Yeppp! library */
	printf("de-initializing\n");
	status = yepLibrary_Release();
	assert(status == YepStatusOk);
	/* Release the memory allocated for arrays */
	printf("freeing\n");
	free(yep_x);
	free(yep_y);
	free(yep_z);
  return new_ary;
}

// The initialization method for this module
void Init_ryeppp() {
  cRyeppp = rb_define_class("Ryeppp", rb_cObject);
  rb_define_singleton_method(cRyeppp, "add_v8sv8s_v8s", add_v8sv8s_v8s, 2);
}
