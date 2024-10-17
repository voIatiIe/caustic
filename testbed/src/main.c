#include <test.h>

#include <core/asserts.h>
#include <core/logger.h>


int main(void) {
    KDEBUG("-");
    KINFO("-");
    KFATAL("-");
    print("Hello, world!\n");

    // CASSERT(1 == 2);
}
