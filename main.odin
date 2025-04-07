package main

import "base:runtime"
import "core:log"
import sapp "sokol/app"
import sg "sokol/gfx"
import shelpers "sokol/helpers"

default_context: runtime.Context


main :: proc() {
	context.logger = log.create_console_logger()
	default_context = context

	sapp.run(
		{
			width = 1280,
			height = 720,
			window_title = "Test",
			allocator = sapp.Allocator(shelpers.allocator(&default_context)),
			logger = sapp.Logger(shelpers.logger(&default_context)),
			init_cb = init_cb,
			frame_cb = frame_cb,
			cleanup_cb = cleanup_cb,
			event_cb = event_cb,
		},
	)
}

init_cb :: proc "c" () {
	context = default_context

	sg.setup(
		{
			environment = shelpers.glue_environment(),
			allocator = sg.Allocator(shelpers.allocator(&default_context)),
			logger = sg.Logger(shelpers.logger(&default_context)),
		},
	)
}

cleanup_cb :: proc "c" () {
	context = default_context

	sg.shutdown()
}

frame_cb :: proc "c" () {
	context = default_context

	sg.begin_pass({swapchain = shelpers.glue_swapchain()})

	// TODO: draw a shape

	sg.end_pass()
	sg.commit()
}

event_cb :: proc "c" (ev: ^sapp.Event) {
	context = default_context

	log.debug(ev.type)
}
