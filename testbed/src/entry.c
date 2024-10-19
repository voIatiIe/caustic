#include <entry.h>
#include <core/logger.h>

#include "game.h"


b8 create_game(game* game_inst) {
    CINFO("Creating game...");

    game_inst->config.name = "Game";
    game_inst->config.x = 200;
    game_inst->config.y = 200;
    game_inst->config.width = 800;
    game_inst->config.height = 600;

    game_inst->init = init;
    game_inst->update = update;
    game_inst->render = render;
    game_inst->on_resize = on_resize;

    // game_inst->state = ...;

    return TRUE;
}
