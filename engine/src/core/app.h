#pragma once

#include "defines.h"
#include "platform/platform.h"

typedef struct app_config {
    char *name;
    i16 x;
    i16 y;
    i16 width;
    i16 height;
} app_config;

typedef struct game {
    app_config config;

    b8 (*init)(struct game* game_inst);
    b8 (*update)(struct game* game_inst);
    b8 (*render)(struct game* game_inst);
    void (*on_resize)(struct game* game_inst, u32 width, u32 height);

    void* state;
} game;

typedef struct app_state {
    game *game_inst;
    u8 is_running;
    u8 is_suspended;
    platform_state platform;
    i16 width;
    i16 height;
} app_state;

CAPI b8 app_create(game* game_inst);
CAPI b8 app_run();
