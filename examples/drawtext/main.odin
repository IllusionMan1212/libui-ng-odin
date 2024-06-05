package libui_drawtext

import "core:c"
import "core:fmt"

import "../../"

mainwin: ^libui.Window
area: ^libui.Area
fontButton: ^libui.FontButton
alignment: ^libui.Combobox
systemFont: ^libui.Checkbox

attrstr: ^libui.AttributedString

appendWithAttribute :: proc(what: cstring, attr: ^libui.Attribute, attr2: ^libui.Attribute) {
	start := libui.AttributedStringLen(attrstr^)
	end := start + len(what)
	libui.AttributedStringAppendUnattributed(attrstr, what)
	libui.AttributedStringSetAttribute(attrstr, attr, start, end)
	if attr2 != nil {
		libui.AttributedStringSetAttribute(attrstr, attr2, start, end)
	}
}

makeAttributedString :: proc() {
	attrstr = libui.NewAttributedString("Drawing strings with libui is done with the uiAttributedString and uiDrawTextLayout objects.\n" + "uiAttributedString lets you have a variety of attributes: ")

	attr := libui.NewFamilyAttribute("Courier New")
	appendWithAttribute("font family", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewSizeAttribute(18)
	appendWithAttribute("font size", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewWeightAttribute(.Bold)
	appendWithAttribute("font weight", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewItalicAttribute(.Italic)
	appendWithAttribute("font italicness", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewStretchAttribute(.Condensed)
	appendWithAttribute("font stretch", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewColorAttribute(0.75, 0.25, 0.5, 0.75)
	appendWithAttribute("text color", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	attr = libui.NewBackgroundAttribute(0.5, 0.5, 0.25, 0.5)
	appendWithAttribute("text background color", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")


	attr = libui.NewUnderlineAttribute(.Single)
	appendWithAttribute("underline style", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, ", ")

	libui.AttributedStringAppendUnattributed(attrstr, "and ")
	attr = libui.NewUnderlineAttribute(.Double)
	attr2 := libui.NewUnderlineColorAttribute(.Custom, 1.0, 0.0, 0.5, 1.0)
	appendWithAttribute("underline color", attr, attr2)
	libui.AttributedStringAppendUnattributed(attrstr, ". ")

	libui.AttributedStringAppendUnattributed(attrstr, "Furthermore, there are attributes allowing for ")
	attr = libui.NewUnderlineAttribute(.Suggestion)
	attr2 = libui.NewUnderlineColorAttribute(.Spelling, 0, 0, 0, 0)
	appendWithAttribute("special underlines for indicating spelling errors", attr, attr2)
	libui.AttributedStringAppendUnattributed(attrstr, " (and other types of errors) ")

	libui.AttributedStringAppendUnattributed(attrstr, "and control over OpenType features such as ligatures (for instance, ")
	otf := libui.NewOpenTypeFeatures()
	libui.OpenTypeFeaturesAdd(otf, 'l', 'i', 'g', 'a', 0)
	attr = libui.NewFeaturesAttribute(otf)
	appendWithAttribute("afford", attr, nil)
	libui.AttributedStringAppendUnattributed(attrstr, " vs. ")
	libui.OpenTypeFeaturesAdd(otf, 'l', 'i', 'g', 'a', 1)
	attr = libui.NewFeaturesAttribute(otf)
	appendWithAttribute("afford", attr, nil)
	libui.FreeOpenTypeFeatures(otf)
	libui.AttributedStringAppendUnattributed(attrstr, ").\n")

	libui.AttributedStringAppendUnattributed(attrstr, "Use the controls opposite to the text to control properties of the text.")
}

handlerDraw :: proc(a: ^libui.AreaHandler, area: ^libui.Area, p: ^libui.AreaDrawParams) {
	defaultFont: libui.FontDescriptor
	params: libui.DrawTextLayoutParams
	useSystemFont := libui.CheckboxChecked(systemFont)

	params.String = attrstr

	if useSystemFont {
		libui.LoadControlFont(&defaultFont)
	} else {
		libui.FontButtonFont(fontButton, &defaultFont)
	}

	params.DefaultFont = &defaultFont
	params.Width = p.AreaWidth
	params.Align = cast(libui.DrawTextAlign)libui.ComboboxSelected(alignment)
	textLayout := libui.DrawNewTextLayout(&params)
	libui.DrawText(p.Context, textLayout, 0, 0)
	libui.DrawFreeTextLayout(textLayout)

	libui.FreeFontButtonFont(&defaultFont)
}

handlerMouseEvent :: proc(a: ^libui.AreaHandler, area: ^libui.Area, e: ^libui.AreaMouseEvent) {
	// do nothing
}

handlerMouseCrossed :: proc(ah: ^libui.AreaHandler, a: ^libui.Area, left: c.int) {
	// do nothing
}

handlerDragBroken :: proc(ah: ^libui.AreaHandler, a: ^libui.Area) {
	// do nothing
}

handlerKeyEvent :: proc(ah: ^libui.AreaHandler, a: ^libui.Area, e: ^libui.AreaKeyEvent) -> c.int {
	// reject all keys
	return 0
}

onFontChanged :: proc "c" (b: ^libui.FontButton, data: rawptr) {
	libui.AreaQueueRedrawAll(area)
}

onComboboxSelected :: proc "c" (b: ^libui.Combobox, data: rawptr) {
	libui.AreaQueueRedrawAll(area)
}

onCheckboxToggled :: proc "c" (b: ^libui.Checkbox, data: rawptr) {
	libui.AreaQueueRedrawAll(area)
}

onClosing :: proc "c" (w: ^libui.Window, data: rawptr) -> b32 {
	libui.ControlDestroy(cast(^libui.Control)mainwin)
	libui.Quit()
	return false
}

shouldQuit :: proc "c" (data: rawptr) -> b32 {
	libui.ControlDestroy(cast(^libui.Control)mainwin)
	return true
}

main :: proc() {
	handler: libui.AreaHandler
	o: libui.InitOptions 

	handler.Draw = handlerDraw
	handler.MouseEvent = handlerMouseEvent
	handler.MouseCrossed = handlerMouseCrossed
	handler.DragBroken = handlerDragBroken
	handler.KeyEvent = handlerKeyEvent

	err := libui.Init(&o)
	if err != nil {
		fmt.eprintln("error initializing ui: %s", err)
		libui.FreeInitError(err)
		return
	}

	libui.OnShouldQuit(shouldQuit, nil)

	makeAttributedString()

	mainwin = libui.NewWindow("libui Text-Drawing Example", 640, 480, true)
	libui.WindowSetMargined(mainwin, true)
	libui.WindowOnClosing(mainwin, onClosing, nil)

	hbox := libui.NewHorizontalBox()
	libui.BoxSetPadded(hbox, true)
	libui.WindowSetChild(mainwin, cast(^libui.Control)hbox)

	vbox := libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.BoxAppend(hbox, cast(^libui.Control)vbox, false)

	fontButton = libui.NewFontButton()
	libui.FontButtonOnChanged(fontButton, onFontChanged, nil)
	libui.BoxAppend(vbox, cast(^libui.Control)fontButton, false)

	form := libui.NewForm()
	libui.FormSetPadded(form, true)
	// on OS X if this is set to 1 then the window can't resize does the form not have the concept of stretchy trailing space?
	libui.BoxAppend(vbox, cast(^libui.Control)form, false)

	alignment = libui.NewCombobox()
	// note that the items match with the values of the uiDrawTextAlign values
	libui.ComboboxAppend(alignment, "Left")
	libui.ComboboxAppend(alignment, "Center")
	libui.ComboboxAppend(alignment, "Right")
	libui.ComboboxSetSelected(alignment, 0)		// start with left alignment
	libui.ComboboxOnSelected(alignment, onComboboxSelected, nil)
	libui.FormAppend(form, "Alignment", cast(^libui.Control)alignment, false)

	systemFont = libui.NewCheckbox("")
	libui.CheckboxOnToggled(systemFont, onCheckboxToggled, nil)
	libui.FormAppend(form, "System Font", cast(^libui.Control)systemFont, false)

	area = libui.NewArea(&handler)
	libui.BoxAppend(hbox, cast(^libui.Control)area, true)

	libui.ControlShow(cast(^libui.Control)mainwin)
	libui.Main()
	libui.FreeAttributedString(attrstr)
	libui.Uninit()
}
