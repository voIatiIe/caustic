#include <test.h>

#include <core/logger.h>
#include <platform/platform.h>


int main(void) {
    print("Hello, world!\n");

    platform_state state;

    if (!platform_startup(&state, "caustic", 100, 100, 800, 400)) {
        CFATAL("Failed to initialize platform");
    }

    while (platform_pump_messages(&state)) {}

    platform_shutdown(&state);

    return 0;
}
