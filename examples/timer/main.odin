package libui_timer

import "core:c"
import "core:c/libc"
import "core:fmt"

import "../../"

e: ^libui.MultilineEntry

sayTime :: proc "c" (data: rawptr) -> c.int {
	t := libc.time(nil)
	s := libc.ctime(&t)

	libui.MultilineEntryAppend(e, cast(cstring)s)
	return 1
}

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	libui.Quit()
	return true
}

saySomething :: proc "c" (b: ^libui.Button, data: rawptr) {
	libui.MultilineEntryAppend(e, "Saying something\n")
}

main :: proc() {
	o: libui.InitOptions

	if libui.Init(&o) != nil {
		fmt.println("Failed to initialize libui")
		return
	}

	w := libui.NewWindow("Hello", 320, 240, false)
	libui.WindowSetMargined(w, true)

	b := libui.NewVerticalBox()
	libui.BoxSetPadded(b, true)
	libui.WindowSetChild(w, cast(^libui.Control)b)

	e = libui.NewMultilineEntry()
	libui.MultilineEntrySetReadOnly(e, true)

	btn := libui.NewButton("Say Something")
	libui.ButtonOnClicked(btn, saySomething, nil)
	libui.BoxAppend(b, cast(^libui.Control)btn, false)

	libui.BoxAppend(b, cast(^libui.Control)e, true)

	libui.Timer(1000, sayTime, nil)

	libui.WindowOnClosing(w, onClosing, nil)
	libui.ControlShow(cast(^libui.Control)w)
	libui.Main()
}
