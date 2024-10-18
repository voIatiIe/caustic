#include "logger.h"
#include "asserts.h"
#include "platform/platform.h"

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
    sprintf(out_message_, "%s%s", level_strings[level], out_message);

    if (level <= LOG_LEVEL_ERROR) {
        platform_console_write(out_message_, level);
    } else {
        platform_console_write_error(out_message_, level);
    }
}

void assertion_failure(const char* expression, const char* message, const char* file, i32 line) {
    log_output(LOG_LEVEL_FATAL, "Assertion Failure: %s, message: '%s', in file: %s, line: %d", expression, message, file, line);
}
