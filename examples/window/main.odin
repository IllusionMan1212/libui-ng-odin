package libui_window

import "core:fmt"

import "../../"

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	libui.Quit()
	return true
}

main :: proc() {
	o: libui.InitOptions

	err := libui.Init(&o)
	if err != nil {
		fmt.eprintln("Error initializing libui-ng: %s", err)
		libui.FreeInitError(err)
		return
	}

	// Create a new window
	w := libui.NewWindow("Window Title", 300, 30, false)

	libui.WindowOnClosing(w, onClosing, nil)
	libui.ControlShow(cast(^libui.Control)w)
	libui.Main()
	libui.Uninit()
}
