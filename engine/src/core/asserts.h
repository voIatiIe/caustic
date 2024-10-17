#pragma once

#include "defines.h"

#define CASSERTIONS_ENABLED 1

CAPI void assertion_failure(const char* expression, const char* message, const char* file, i32 line);

#ifdef CASSERTIONS_ENABLED
    #if _MSC_VER
        #include <intrin.h>
        #define debug_break() __debugbreak()
    #else
        #define debug_break() __builtin_trap()
    #endif

    #define CASSERT(expr) { if (expr) {} else {assertion_failure(#expr, "", __FILE__, __LINE__); debug_break();}}

#else
    #define CASSERT(expr)
#endif
