#include "app.h"

#include "logger.h"
#include "platform/platform.h"


static b8 is_initialized = FALSE;
static app_state state;

b8 app_create(game* game_inst) {
    if (is_initialized) {
        CERROR("Trying to create application more than once");
        return FALSE;
    }

    state.is_running = TRUE;
    state.is_suspended = FALSE;

    state.game_inst = game_inst;

    state.width = game_inst->config.width;
    state.height = game_inst->config.height;

    if (!platform_startup(
        &state.platform,
        state.game_inst->config.name,
        state.game_inst->config.x,
        state.game_inst->config.y,
        state.game_inst->config.width,
        state.game_inst->config.height
    )) {
        CFATAL("Failed to initialize platform");
        return FALSE;
    }

    state.game_inst->on_resize(state.game_inst, state.width, state.height);

    is_initialized = TRUE;

    return TRUE;
};


b8 app_run() {
    while (state.is_running) {
        if (!platform_pump_messages(&state.platform)) {
            break;
        }

        if (!state.is_suspended) {
            if (!state.game_inst->update(state.game_inst)) {
                CFATAL("Game update failed");
                break;
            }

            if (!state.game_inst->render(state.game_inst)) {
                CFATAL("Game render failed");
                break;
            }
        }
    }

    state.is_running = FALSE;

    platform_shutdown(&state.platform);

    return TRUE;
};
