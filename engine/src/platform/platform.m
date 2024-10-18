#include "platform.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class ApplicationDelegate;
@class WindowDelegate;
@class ContentView;

typedef struct internal_state {
    ApplicationDelegate* app_delegate;
    WindowDelegate* wnd_delegate;
    NSWindow* window;
    ContentView* view;
    CAMetalLayer* layer;
    b8 quit_flagged;
} internal_state;


@interface ApplicationDelegate : NSObject <NSApplicationDelegate> {} @end // ApplicationDelegate

@implementation ApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    @autoreleasepool {

        // TODO: what is the purpose of this event? Without in [NSApp stop:nil]; won't work...
        NSEvent* event = [
            NSEvent otherEventWithType:NSEventTypeApplicationDefined
                    location:NSMakePoint(0, 0)
                    modifierFlags:0
                    timestamp:0
                    windowNumber:0
                    context:nil
                    subtype:0
                    data1:0
                    data2:0
        ];
        [NSApp postEvent:event atStart:YES];

    } // autoreleasepool

    [NSApp stop:nil];
}

@end // ApplicationDelegate


@interface WindowDelegate : NSObject <NSWindowDelegate> {
    internal_state* state;
}

- (instancetype)initWithState:(internal_state*)init_state;

@end // WindowDelegate

@implementation WindowDelegate

- (instancetype)initWithState:(internal_state*)init_state {
    self = [super init];
    
    if (self != nil) {
        state = init_state;
        state->quit_flagged = FALSE;
    }
    
    return self;
}

- (BOOL)windowShouldClose:(id)sender {
    state->quit_flagged = TRUE;

    return YES;
}

- (void)windowDidResize:(NSNotification *)notification {
}

- (void)windowDidMiniaturize:(NSNotification *)notification {
    [state->window miniaturize:nil];
}

- (void)windowDidDeminiaturize:(NSNotification *)notification {
    [state->window deminiaturize:nil];
}

@end // WindowDelegate

@interface ContentView : NSView <NSTextInputClient> {
    NSWindow* window;
}

- (instancetype)initWithWindow:(NSWindow*)initWindow;

@end // ContentView

@implementation ContentView

- (instancetype)initWithWindow:(NSWindow*)initWindow {
    self = [super init];
    if (self != nil) {
        window = initWindow;
    }

    return self;
}

// TODO: why runtime error without it?
- (NSArray<NSAttributedStringKey> *)validAttributesForMarkedText {return [NSArray array];}

@end // ContentView


b8 platform_startup(
    platform_state* plat_state,
    const char* application_name,
    i32 x,
    i32 y,
    i32 width,
    i32 height
) {
    plat_state->internal_state = malloc(sizeof(internal_state));
    internal_state* state = (internal_state*)plat_state->internal_state;

    @autoreleasepool {

        [NSApplication sharedApplication];

        state->app_delegate = [[ApplicationDelegate alloc] init];
        if (!state->app_delegate) {
            CERROR("Failed to create application delegate");
            return FALSE;
        }
        [NSApp setDelegate:state->app_delegate];

        state->wnd_delegate = [[WindowDelegate alloc] initWithState:state];
        if (!state->wnd_delegate) {
            CERROR("Failed to create window delegate")
            return FALSE;
        }

        state->window = [[NSWindow alloc]
            initWithContentRect:NSMakeRect(x, y, width, height)
            styleMask:NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
            backing:NSBackingStoreBuffered
            defer:NO
        ];
        if (!state->window) {
            CERROR("Failed to create window")
            return FALSE;
        }

        state->layer = [CAMetalLayer layer];
        if (!state->layer) {
            CERROR("Failed to create layer");
            return FALSE;
        }

        state->view = [[ContentView alloc] initWithWindow:state->window];
        [state->view setLayer:state->layer];
        [state->view setWantsLayer:YES];

        [state->window setLevel:NSNormalWindowLevel];
        [state->window setContentView:state->view];
        [state->window makeFirstResponder:state->view];
        [state->window setTitle:@(application_name)];
        [state->window setDelegate:state->wnd_delegate];
        [state->window setAcceptsMouseMovedEvents:YES];
        [state->window setRestorable:NO];

        if (![[NSRunningApplication currentApplication] isFinishedLaunching]) {
            [NSApp run];
        }

        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

        [NSApp activateIgnoringOtherApps:YES];
        [state->window makeKeyAndOrderFront:nil];
    }

    return TRUE;
}

void platform_shutdown(platform_state *plat_state) {
    internal_state* state = (internal_state*)plat_state->internal_state;

    @autoreleasepool {

        if (state->app_delegate) {
            [NSApp setDelegate:nil];
            [state->app_delegate release];
            state->app_delegate = nil;
        }

        if (state->wnd_delegate) {
            // TODO: causes segfault on window close
            // [state->window setDelegate:nil];
            [state->wnd_delegate release];
            state->wnd_delegate = nil;
        }
        
        if (state->view) {
            [state->view release];
            state->view = nil;
        }

        if (state->window) {
            // TODO: causes segfault on window close
            // [state->window close];
            // state->window = nil;
        }

    }
}


b8 platform_pump_messages(platform_state *plat_state) {
    internal_state* state = (internal_state*)plat_state->internal_state;

    @autoreleasepool {

        NSEvent* event;

        while (TRUE) {
            event = [NSApp 
                nextEventMatchingMask:NSEventMaskAny
                untilDate:[NSDate distantPast]
                inMode:NSDefaultRunLoopMode
                dequeue:YES];

            if (!event)
                break;

            [NSApp sendEvent:event];
        }

    }

    return !state->quit_flagged;
}
