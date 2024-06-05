package libui_multithread

import "base:runtime"
import "core:c/libc"
import "core:thread"
import "core:sync"
import "core:mem"
import "core:time"

import "../../"

// BUG: The program segfaults on exit. Not sure how to fix it.

e: ^libui.MultilineEntry
cv: sync.Cond
m: sync.Mutex
timeThread: ^thread.Thread

sayTime :: proc "c" (data: rawptr) {
	context = runtime.default_context()
	s := transmute(cstring)data

	libui.MultilineEntryAppend(e, s)
	delete(s)
}

threadproc :: proc() {
	sync.lock(&m)
	for !sync.cond_wait_with_timeout(&cv, &m, time.Second) {
		s: cstring

		t := libc.time(nil)
		base := transmute(cstring)libc.ctime(&t)
		mem.copy(&s, &base, len(base))
		libui.QueueMain(sayTime, transmute(rawptr)s)
	}
}

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	context = runtime.default_context()
	sync.cond_broadcast(&cv)
	thread.join(timeThread)
	libui.Quit()
	return true
}

saySomething :: proc "c" (b: ^libui.Button, data: rawptr) {
	libui.MultilineEntryAppend(e, "Saying something\n")
}

main :: proc() {
	o: libui.InitOptions

	if libui.Init(&o) != nil {
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

	timeThread = thread.create_and_start(threadproc)

	libui.WindowOnClosing(w, onClosing, nil)
	libui.ControlShow(cast(^libui.Control)w)
	libui.Main()
}
