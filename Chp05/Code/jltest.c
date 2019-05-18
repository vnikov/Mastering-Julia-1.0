#include <julia.h>
#include <stdio.h>
#include <math.h>

// Define this once if in an executable (not in a shared library) ...
// ...  if you want fast code.

JULIA_DEFINE_FAST_TLS()

int main(int argc, char *argv[]) {
    /* required: setup the Julia context */
    jl_init();

    /* run Julia commands */
    jl_function_t *fnc1 = jl_get_function(jl_base_module, "exp");
    jl_function_t *fnc2 = jl_get_function(jl_base_module, "sin");
    jl_value_t* arg1 = jl_box_float64(-0.3);
    jl_value_t* arg2 = jl_box_float64(3.0);
    jl_value_t* ret1 = jl_call1(fnc1, arg1);
    jl_value_t* ret2 = jl_call1(fnc2, arg2);

    /* unbox and setup final result */
    double retD1 = jl_unbox_float64(ret1);
    double retD2 = jl_unbox_float64(ret2);
    double retD3 = retD1*retD2;
    printf("sin(3.0)*exp(-0.3) from Julia API: %e\n", retD3);
    fflush(stdout);

    /* Allow Julia time to cleanup pending write requests etc. */
    jl_atexit_hook(0);
    return 0;
}

