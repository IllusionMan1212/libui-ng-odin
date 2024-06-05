package libui_controlgallery

import "core:fmt"

import "../../"

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	libui.Quit()
	return true
}

onShouldQuit :: proc "c" (data: rawptr) -> b32 {
	mainwin = transmute(^libui.Window)data

	libui.ControlDestroy(cast(^libui.Control)mainwin)
	return true
}

makeBasicControlsPage :: proc() -> ^libui.Control {
	vbox := libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)

	hbox := libui.NewHorizontalBox()
	libui.BoxSetPadded(hbox, true)
	libui.BoxAppend(vbox, cast(^libui.Control)hbox, false)

	libui.BoxAppend(hbox,
		cast(^libui.Control)libui.NewButton("Button"),
		false)
	libui.BoxAppend(hbox,
		cast(^libui.Control)libui.NewCheckbox("Checkbox"),
		false)

	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewLabel("This is a label.\nLabels can span multiple lines."),
		false)

	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewHorizontalSeparator(),
		false)

	group := libui.NewGroup("Entries")
	libui.GroupSetMargined(group, true)
	libui.BoxAppend(vbox, cast(^libui.Control)group, true)

	entryForm := libui.NewForm()
	libui.FormSetPadded(entryForm, true)
	libui.GroupSetChild(group, cast(^libui.Control)entryForm)

	libui.FormAppend(entryForm,
		"Entry",
		cast(^libui.Control)libui.NewEntry(),
		false)
	libui.FormAppend(entryForm,
		"Password Entry",
		cast(^libui.Control)libui.NewPasswordEntry(),
		false)
	libui.FormAppend(entryForm,
		"Search Entry",
		cast(^libui.Control)libui.NewSearchEntry(),
		false)
	libui.FormAppend(entryForm,
		"Multiline Entry",
		cast(^libui.Control)libui.NewMultilineEntry(),
		true)
	libui.FormAppend(entryForm,
		"Multiline Entry No Wrap",
		cast(^libui.Control)libui.NewNonWrappingMultilineEntry(),
		true)

	return cast(^libui.Control)vbox
}

spinbox: ^libui.Spinbox
slider: ^libui.Slider
pbar: ^libui.ProgressBar

onSpinboxChanged :: proc "c" (s: ^libui.Spinbox, data: rawptr) {
	libui.SliderSetValue(slider, libui.SpinboxValue(s))
	libui.ProgressBarSetValue(pbar, libui.SpinboxValue(s))
}

onSliderChanged :: proc "c" (s: ^libui.Slider, data: rawptr) {
	libui.SpinboxSetValue(spinbox, libui.SliderValue(s))
	libui.ProgressBarSetValue(pbar, libui.SliderValue(s))
}

makeNumbersPage :: proc() -> ^libui.Control {
	hbox := libui.NewHorizontalBox()
	libui.BoxSetPadded(hbox, true)

	group := libui.NewGroup("Numbers")
	libui.GroupSetMargined(group, true)
	libui.BoxAppend(hbox, cast(^libui.Control)group, true)

	vbox := libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.GroupSetChild(group, cast(^libui.Control)vbox)

	spinbox = libui.NewSpinbox(0, 100)
	slider = libui.NewSlider(0, 100)
	pbar = libui.NewProgressBar()
	libui.SpinboxOnChanged(spinbox, onSpinboxChanged, nil)
	libui.SliderOnChanged(slider, onSliderChanged, nil)
	libui.BoxAppend(vbox, cast(^libui.Control)spinbox, false)
	libui.BoxAppend(vbox, cast(^libui.Control)slider, false)
	libui.BoxAppend(vbox, cast(^libui.Control)pbar, false)

	ip := libui.NewProgressBar()
	libui.ProgressBarSetValue(ip, -1)
	libui.BoxAppend(vbox, cast(^libui.Control)ip, false)

	group = libui.NewGroup("Lists")
	libui.GroupSetMargined(group, true)
	libui.BoxAppend(hbox, cast(^libui.Control)group, true)

	vbox = libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.GroupSetChild(group, cast(^libui.Control)vbox)

	cbox := libui.NewCombobox()
	libui.ComboboxAppend(cbox, "Combobox Item 1")
	libui.ComboboxAppend(cbox, "Combobox Item 2")
	libui.ComboboxAppend(cbox, "Combobox Item 3")
	libui.BoxAppend(vbox, cast(^libui.Control)cbox, false)

	ecbox := libui.NewEditableCombobox()
	libui.EditableComboboxAppend(ecbox, "Editable Item 1")
	libui.EditableComboboxAppend(ecbox, "Editable Item 2")
	libui.EditableComboboxAppend(ecbox, "Editable Item 3")
	libui.BoxAppend(vbox, cast(^libui.Control)ecbox, false)

	rb := libui.NewRadioButtons()
	libui.RadioButtonsAppend(rb, "Radio Button 1")
	libui.RadioButtonsAppend(rb, "Radio Button 2")
	libui.RadioButtonsAppend(rb, "Radio Button 3")
	libui.BoxAppend(vbox, cast(^libui.Control)rb, false)

	return cast(^libui.Control)hbox
}

mainwin: ^libui.Window

onOpenFileClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	entry := transmute(^libui.Entry)data

	filename := libui.OpenFile(mainwin)
	if filename == nil {
		libui.EntrySetText(entry, "(cancelled)")
		return
	}
	libui.EntrySetText(entry, filename)
	libui.FreeText(filename)
}

onOpenFolderClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	entry := transmute(^libui.Entry)data

	filename := libui.OpenFolder(mainwin)
	if filename == nil {
		libui.EntrySetText(entry, "(cancelled)")
		return
	}
	libui.EntrySetText(entry, filename)
	libui.FreeText(filename)
}

onSaveFileClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	entry := transmute(^libui.Entry)data

	filename := libui.SaveFile(mainwin)
	if filename == nil {
		libui.EntrySetText(entry, "(cancelled)")
		return
	}
	libui.EntrySetText(entry, filename)
	libui.FreeText(filename)
}

onMsgBoxClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	libui.MsgBox(mainwin, "This is a normal message box.", "More detailed information can be shown here.")
}

onMsgBoxErrorClicked :: proc "c" (b: ^libui.Button, data: rawptr) {
	libui.MsgBoxError(mainwin, "This message box describes an error.", "More detailed information can be shown here.")
}

makeDataChoosersPage :: proc() -> ^libui.Control {
	hbox := libui.NewHorizontalBox()
	libui.BoxSetPadded(hbox, true)

	vbox := libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.BoxAppend(hbox, cast(^libui.Control)vbox, false)

	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewDatePicker(),
		false)
	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewTimePicker(),
		false)
	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewDateTimePicker(),
		false)

	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewFontButton(),
		false)
	libui.BoxAppend(vbox,
		cast(^libui.Control)libui.NewColorButton(),
		false)

	libui.BoxAppend(hbox,
		cast(^libui.Control)libui.NewVerticalSeparator(),
		false)

	vbox = libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.BoxAppend(hbox, cast(^libui.Control)vbox, true)

	grid := libui.NewGrid()
	libui.GridSetPadded(grid, true)
	libui.BoxAppend(vbox, cast(^libui.Control)grid, false)

	button := libui.NewButton("  Open File  ")
	entry := libui.NewEntry()
	libui.EntrySetReadOnly(entry, true)
	libui.ButtonOnClicked(button, onOpenFileClicked, entry)
	libui.GridAppend(grid, cast(^libui.Control)button,
		0, 0, 1, 1,
		false, .Fill, false, .Fill)
	libui.GridAppend(grid, cast(^libui.Control)entry,
		1, 0, 1, 1,
		true, .Fill, false, .Fill)

	button = libui.NewButton("Open Folder")
	entry = libui.NewEntry()
	libui.EntrySetReadOnly(entry, true)
	libui.ButtonOnClicked(button, onOpenFolderClicked, entry)
	libui.GridAppend(grid, cast(^libui.Control)button,
		0, 1, 1, 1,
		false, .Fill, false, .Fill)
	libui.GridAppend(grid, cast(^libui.Control)entry,
		1, 1, 1, 1,
		true, .Fill, false, .Fill)

	button = libui.NewButton("  Save File  ")
	entry = libui.NewEntry()
	libui.EntrySetReadOnly(entry, true)
	libui.ButtonOnClicked(button, onSaveFileClicked, entry)
	libui.GridAppend(grid, cast(^libui.Control)button,
		0, 2, 1, 1,
		false, .Fill, false, .Fill)
	libui.GridAppend(grid, cast(^libui.Control)entry,
		1, 2, 1, 1,
		true, .Fill, false, .Fill)

	msggrid := libui.NewGrid()
	libui.GridSetPadded(msggrid, true)
	libui.GridAppend(grid, cast(^libui.Control)msggrid,
		0, 3, 2, 1,
		false, .Center, false, .Start)

	button = libui.NewButton("Message Box")
	libui.ButtonOnClicked(button, onMsgBoxClicked, nil)
	libui.GridAppend(msggrid, cast(^libui.Control)button,
		0, 0, 1, 1,
		false, .Fill, false, .Fill)
	button = libui.NewButton("Error Box")
	libui.ButtonOnClicked(button, onMsgBoxErrorClicked, nil)
	libui.GridAppend(msggrid, cast(^libui.Control)button,
		1, 0, 1, 1,
		false, .Fill, false, .Fill)

	return cast(^libui.Control)hbox
}

main :: proc() {
	options: libui.InitOptions

	err := libui.Init(&options)
	if err != nil {
		fmt.eprintln("error initializing libui: %s", err)
		libui.FreeInitError(err)
		return
	}

	mainwin = libui.NewWindow("libui Control Gallery", 640, 480, true)
	libui.WindowOnClosing(mainwin, onClosing, nil)
	libui.OnShouldQuit(onShouldQuit, mainwin)

	tab := libui.NewTab()
	libui.WindowSetChild(mainwin, cast(^libui.Control)tab)
	libui.WindowSetMargined(mainwin, true)

	libui.TabAppend(tab, "Basic Controls", makeBasicControlsPage())
	libui.TabSetMargined(tab, 0, true)

	libui.TabAppend(tab, "Numbers and Lists", makeNumbersPage())
	libui.TabSetMargined(tab, 1, true)

	libui.TabAppend(tab, "Data Choosers", makeDataChoosersPage())
	libui.TabSetMargined(tab, 2, true)

	libui.ControlShow(cast(^libui.Control)mainwin)
	libui.Main()
}
