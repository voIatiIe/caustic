#pragma once

#include "defines.h"
#include "core/app.h"
#include "core/logger.h"


extern b8 create_game(game* game_inst);


int main(void) {
    game game_inst;

    if (!create_game(&game_inst)) {
        CFATAL("Could not create game!");
        return -1;
    }

    if (!game_inst.render || !game_inst.update || !game_inst.init || !game_inst.on_resize) {
        CFATAL("The game's function pointers must be assigned!");
        return -2;
    }

    if (!app_create(&game_inst)) {
        CFATAL("Failed to create application!");
        return -3;
    }

    if (!app_run()) {
        CERROR("Application did not shutdown gracefully!");
        return -4;
    }

    return 0;
}
