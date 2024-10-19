#pragma once

#include <core/app.h>
#include <defines.h>


typedef struct game_state {
    f32 delta;
} game_state;

b8 init(game* game_inst);
b8 update(game* game_inst);
b8 render(game* game_inst);
void on_resize(game* game_inst, u32 width, u32 height);
