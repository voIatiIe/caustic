#include "logger.h"
#include "asserts.h"

#include <stdio.h>
#include <string.h>
#include <stdarg.h>


b8 initialize_logging() {
    return TRUE;
};

void shutdown_logging() {};


void log_output(log_level level, const char* message, ...) {
    const char* level_strings[6] = {"[FATAL]: ", "[ERROR]: ", "[WARN]:  ", "[INFO]:  ", "[DEBUG]: ", "[TRACE]: "};

    const i16 msg_len = 32000;

    char out_message[msg_len];
    memset(out_message, 0, sizeof(out_message));

    __builtin_va_list args;
    va_start(args, message);
    vsnprintf(out_message, msg_len, message, args);
    va_end(args);

    char out_message_[msg_len];
    sprintf(out_message_, "%s%s\n", level_strings[level], out_message);

    printf("%s", out_message_);
}

void assertion_failure(const char* expression, const char* message, const char* file, i32 line) {
    CFATAL("Assertion Failure: %s, message: '%s', in file: %s, line: %d\n", expression, message, file, line);
}
