package libui_datetime

import "base:runtime"
import "core:fmt"
import "core:c/libc"

import "../../"

dtboth, dtdate, dttime: ^libui.DateTimePicker 

timeFormat :: proc(d: ^libui.DateTimePicker) -> cstring {
	if d == dtboth {
		return "%c"
	} else if d == dtdate {
		return "%x"
	} else if d == dttime {
		return "%X"
	}

	return ""
}

onChanged :: proc "c" (d: ^libui.DateTimePicker, data: rawptr) {
	context = runtime.default_context()
	time: libc.tm
	buf: [64]i8

	libui.DateTimePickerTime(d, &time)
	libc.strftime(cast([^]u8)&buf, size_of(buf), timeFormat(d), &time)
	libui.LabelSetText(transmute(^libui.Label)data, transmute(cstring)&buf[0])
}

onClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	t: libc.time_t
	tmbuf: libc.tm

	now := cast(bool)transmute(int)data
	t = 0
	if (now) {
		t = libc.time(nil)
	}
	tmbuf = libc.localtime(&t)^

	if (now) {
		libui.DateTimePickerSetTime(dtdate, tmbuf)
		libui.DateTimePickerSetTime(dttime, tmbuf)
	} else {
		libui.DateTimePickerSetTime(dtboth, tmbuf)
	}
}

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	libui.Quit()
	return true
}

main :: proc() {
	o: libui.InitOptions 
	g: ^libui.Grid
	l: ^libui.Label
	b: ^libui.Button

	err := libui.Init(&o)
	if err != nil {
		fmt.eprintln("error initializing ui: %s", err)
		libui.FreeInitError(err)
		return
	}

	w := libui.NewWindow("Date / Time", 320, 240, false)
	libui.WindowSetMargined(w, true)

	g = libui.NewGrid()
	libui.GridSetPadded(g, true)
	libui.WindowSetChild(w, cast(^libui.Control)g)

	dtboth = libui.NewDateTimePicker()
	dtdate = libui.NewDatePicker()
	dttime = libui.NewTimePicker()

	libui.GridAppend(g, cast(^libui.Control)dtboth,
		0, 0, 2, 1,
		true, .Fill, false, .Fill)
	libui.GridAppend(g, cast(^libui.Control)dtdate,
		0, 1, 1, 1,
		true, .Fill, false, .Fill)
	libui.GridAppend(g, cast(^libui.Control)dttime,
		1, 1, 1, 1,
		true, .Fill, false, .Fill)

	l = libui.NewLabel("")
	libui.GridAppend(g, cast(^libui.Control)l,
		0, 2, 2, 1,
		true, .Center, false, .Fill)
	libui.DateTimePickerOnChanged(dtboth, onChanged, l)
	l = libui.NewLabel("")
	libui.GridAppend(g, cast(^libui.Control)l,
		0, 3, 1, 1,
		true, .Center, false, .Fill)
	libui.DateTimePickerOnChanged(dtdate, onChanged, l)
	l = libui.NewLabel("")
	libui.GridAppend(g, cast(^libui.Control)l,
		1, 3, 1, 1,
		true, .Center, false, .Fill)
	libui.DateTimePickerOnChanged(dttime, onChanged, l)

	b = libui.NewButton("Now")
	libui.ButtonOnClicked(b, onClicked, cast(rawptr)uintptr(1))
	libui.GridAppend(g, cast(^libui.Control)b,
		0, 4, 1, 1,
		true, .Fill, true, .End)
	b = libui.NewButton("Unix epoch")
	libui.ButtonOnClicked(b, onClicked, cast(rawptr)uintptr(0))
	libui.GridAppend(g, cast(^libui.Control)b,
		1, 4, 1, 1,
		true, .Fill, true, .End)

	libui.WindowOnClosing(w, onClosing, nil)
	libui.ControlShow(cast(^libui.Control)w)
	libui.Main()
}
