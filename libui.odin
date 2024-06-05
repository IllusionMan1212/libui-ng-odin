package libui

// Based on commit: 49b04c4cf8ae4d3e38e389f446ef75170eb62762 - June 4th 2024

import "core:c"
import "core:c/libc"

when ODIN_OS == .Linux {
	foreign import libui {
		"libs/libui.a",
		"system:gtk-3",
		"system:gdk-3",
		"system:glib-2.0",
		"system:gobject-2.0",
		"system:cairo",
		"system:pangocairo-1.0",
		"system:pango-1.0",
	}
}

// this is the default for botoh cairo and Direct2D (in the latter case, from the C++ helper functions)
// Core Graphics doesn't explicitly specify a default, but NSBezierPath allows you to choose one, and this is the initial value
// so we're good to use it too!
DrawDefaultMiterLimit :: 10.0

/** Parameter to editable model columns to signify all rows are never editable. */
TableModelColumnNeverEditable: int : -1
/** Parameter to editable model columns to signify all rows are always editable. */
TableModelColumnAlwaysEditable: int : -2

ForEach :: enum c.uint {
	Continue,
	Stop,
}

ModifiersMask :: enum c.uint {
	Ctrl, //!< Control key.
	Alt, //!< Alternate/Option key.
	Shift, //!< Shift key.
	Super, //!< Super/Command/Windows key.
}

Modifiers :: bit_set[ModifiersMask; c.uint]

ExtKey :: enum c.uint {
	Escape = 1,
	Insert,			// equivalent to "Help" on Apple keyboards
	Delete,
	Home,
	End,
	PageUp,
	PageDown,
	Up,
	Down,
	Left,
	Right,
	F1,			// F1..F12 are guaranteed to be consecutive
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	F10,
	F11,
	F12,
	N0,			// numpad keys; independent of Num Lock state
	N1,			// N0..N9 are guaranteed to be consecutive
	N2,
	N3,
	N4,
	N5,
	N6,
	N7,
	N8,
	N9,
	NDot,
	NEnter,
	NAdd,
	NSubtract,
	NMultiply,
	NDivide,
}

WindowResizeEdge :: enum c.uint {
	Left,
	Top,
	Right,
	Bottom,
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight,
}

DrawBrushType :: enum c.uint {
	Solid,
	LinearGradient,
	RadialGradient,
	Image,
}

DrawLineCap :: enum c.uint {
	Flat,
	Round,
	Square,
}

DrawLineJoin :: enum c.uint {
	Miter,
	Round,
	Bevel,
}

DrawFillMode :: enum c.uint {
	Winding,
	Alternate,
}

// uiAttributeType holds the possible uiAttribute types that may be
// returned by uiAttributeGetType(). Refer to the documentation for
// each type's constructor function for details on each type.
AttributeType :: enum c.uint {
	Family,
	Size,
	Weight,
	Italic,
	Stretch,
	Color,
	Background,
	Underline,
	UnderlineColor,
	Features,
}

// uiTextWeight represents possible text weights. These roughly
// map to the OS/2 text weight field of TrueType and OpenType
// fonts, or to CSS weight numbers. The named constants are
// nominal values; the actual values may vary by font and by OS,
// though this isn't particularly likely. Any value between
// uiTextWeightMinimum and uiTextWeightMaximum, inclusive,
// is allowed.
//
// Note that due to restrictions in early versions of Windows, some
// fonts have "special" weights be exposed in many programs as
// separate font families. This is perhaps most notable with
// Arial Black. libui does not do this, even on Windows (because the
// DirectWrite API libui uses on Windows does not do this); to
// specify Arial Black, use family Arial and weight uiTextWeightBlack.
TextWeight :: enum c.uint {
	Minimum = 0,
	Thin = 100,
	UltraLight = 200,
	Light = 300,
	Book = 350,
	Normal = 400,
	Medium = 500,
	SemiBold = 600,
	Bold = 700,
	UltraBold = 800,
	Heavy = 900,
	UltraHeavy = 950,
	Maximum = 1000,
}

// uiTextItalic represents possible italic modes for a font. Italic
// represents "true" italics where the slanted glyphs have custom
// shapes, whereas oblique represents italics that are merely slanted
// versions of the normal glyphs. Most fonts usually have one or the
// other.
TextItalic :: enum c.uint {
	Normal,
	Oblique,
	Italic,
}

// uiTextStretch represents possible stretches (also called "widths")
// of a font.
//
// Note that due to restrictions in early versions of Windows, some
// fonts have "special" stretches be exposed in many programs as
// separate font families. This is perhaps most notable with
// Arial Condensed. libui does not do this, even on Windows (because
// the DirectWrite API libui uses on Windows does not do this); to
// specify Arial Condensed, use family Arial and stretch
// uiTextStretchCondensed.
TextStretch :: enum c.uint {
	UltraCondensed,
	ExtraCondensed,
	Condensed,
	SemiCondensed,
	Normal,
	SemiExpanded,
	Expanded,
	ExtraExpanded,
	UltraExpanded,
}

// uiUnderline specifies a type of underline to use on text.
Underline :: enum c.uint {
	None,
	Single,
	Double,
	Suggestion,		// wavy or dotted underlines used for spelling/grammar checkers
}

// uiUnderlineColor specifies the color of any underline on the text it
// is applied to, regardless of the type of underline. In addition to
// being able to specify a custom color, you can explicitly specify
// platform-specific colors for suggestion underlines; to use them
// correctly, pair them with uiUnderlineSuggestion (though they can
// be used on other types of underline as well).
//
// If an underline type is applied but no underline color is
// specified, the text color is used instead. If an underline color
// is specified without an underline type, the underline color
// attribute is ignored, but not removed from the uiAttributedString.
UnderlineColor :: enum c.uint {
	Custom,
	Spelling,
	Grammar,
	Auxiliary,		// for instance, the color used by smart replacements on macOS or in Microsoft Office
}

// uiDrawTextAlign specifies the alignment of lines of text in a
// uiDrawTextLayout.
DrawTextAlign :: enum c.uint {
	Left,
	Center,
	Right,
}

/**
 * Alignment specifiers to define placement within the reserved area.
 *
 * Used in uiGrid.
 * @enum uiAlign
 */
Align :: enum c.uint {
	Fill,	//!< Fill area.
	Start,	//!< Place at start.
	Center,	//!< Place in center.
	End,	//!< Place at end.
}

/**
 * Placement specifier to define placement in relation to another control.
 *
 * Used in uiGrid.
 * @enum uiAt
 */
At :: enum c.uint {
	Leading,	//!< Place before control.
	Top,	//!< Place above control.
	Trailing,	//!< Place behind control.
	Bottom,	//!< Place below control.
}

/**
 * uiTableValue types.
 *
 * @todo Define whether calling any of the getters on the wrong type is
 *       undefined behavior or caught error.
 * @enum uiTableValueType
 */
TableValueType :: enum c.uint {
	String,
	Image,
	Int,
	Color,
}

/**
 * Sort indicators.
 *
 * Generic sort indicators to display sorting direction.
 *
 * @enum uiSortIndicator
 * @ingroup table
 */
SortIndicator :: enum c.uint {
	None,
	Ascending,
	Descending
}

/**
 * Table selection modes.
 *
 * Table selection that enforce how a user can interact with a table.
 *
 * @warning An empty table selection is a valid state for any selection mode.
 *          This is in fact the default upon table creation and can otherwise
 *          triggered through operations such as row deletion.
 *
 * @enum uiTableSelectionMode
 * @ingroup table
 */
TableSelectionMode :: enum c.uint {
	/**
	 * Allow no row selection.
	 *
	 * @warning This mode disables all editing of text columns. Buttons
	 * and checkboxes keep working though.
	 */
	 None,
	 ZeroOrOne,  //!< Allow zero or one row to be selected.
	 One,        //!< Allow for exactly one row to be selected.
	 ZeroOrMany, //!< Allow zero or many (multiple) rows to be selected.
}


InitOptions :: struct {
	Size: int,
}

/**
 * Base class for GUI controls providing common methods.
 *
 * @struct Control
 */
Control :: struct {
	Signature: c.uint32_t,
	OSSignature: c.uint32_t,
	TypeSignature: c.uint32_t,
	Destroy: #type proc(_: ^Control),
	Handle: #type proc(_: ^Control) -> c.uintptr_t,
	Parent: #type proc(_: ^Control) -> ^Control,
	SetParent: #type proc(_: ^Control, __: ^Control),
	Toplevel: #type proc(_: ^Control) -> c.int,
	Visible: #type proc(_: ^Control) -> c.int,
	Show: #type proc(_: ^Control),
	Hide: #type proc(_: ^Control),
	Enabled: #type proc(_: ^Control) -> c.int,
	Enable: #type proc(_: ^Control),
	Disable: #type proc(_: ^Control),
}

/**
 * A control that represents a top-level window.
 *
 * A window contains exactly one child control that occupied the entire window.
 *
 * @note Many of the uiWindow methods should be regarded as mere hints.
 *       The underlying system may override these or even choose to ignore them
 *       completely. This is especially true for many Unix systems.
 *
 * @warning A uiWindow can NOT be a child of another Control.
 *
 * @struct uiWindow
 * @extends Control
 * @ingroup container
 */
Window :: distinct Control

/**
 * A control that visually represents a button to be clicked by the user to trigger an action.
 *
 * @struct uiButton
 * @extends uiControl
 * @ingroup button
 */
Button :: distinct Control

/**
 * A boxlike container that holds a group of controls.
 *
 * The contained controls are arranged to be displayed either horizontally or
 * vertically next to each other.
 *
 * @struct uiBox
 * @extends uiControl
 * @ingroup container
 */
Box :: distinct Control

/**
 * A control with a user checkable box accompanied by a text label.
 *
 * @struct uiCheckbox
 * @extends uiControl
 * @ingroup dataEntry
 */
Checkbox :: distinct Control

/**
 * A control with a single line text entry field.
 *
 * @struct uiEntry
 * @extends uiControl
 * @ingroup dataEntry
 */
Entry :: distinct Control

/**
 * A control that displays non interactive text.
 *
 * @struct uiLabel
 * @extends uiControl
 * @ingroup static
 */
Label :: distinct Control

/**
 * A multi page control interface that displays one page at a time.
 *
 * Each page/tab has an associated label that can be selected to switch
 * between pages/tabs.
 *
 * @struct uiTab
 * @extends uiControl
 * @ingroup container
 */
Tab :: distinct Control

/**
 * A control container that adds a label to the contained child control.
 *
 * This control is a great way of grouping related controls in combination with
 * uiBox.
 *
 * A visual box will or will not be drawn around the child control dependent
 * on the underlying OS implementation.
 *
 * @struct uiGroup
 * @extends uiControl
 * @ingroup container
 */
Group :: distinct Control

/**
 * A control to display and modify integer values via a text field or +/- buttons.
 *
 * This is a convenient control for having the user enter integer values.
 * Values are guaranteed to be within the specified range.
 *
 * The + button increases the held value by 1.\n
 * The - button decreased the held value by 1.
 *
 * Entering a value out of range will clamp to the nearest value in range.
 *
 * @struct uiSpinbox
 * @extends uiControl
 * @ingroup dataEntry
 */
Spinbox :: distinct Control

/**
 * A control to display and modify integer values via a user draggable slider.
 *
 * Values are guaranteed to be within the specified range.
 *
 * Sliders by default display a tool tip showing the current value when being
 * dragged.
 *
 * Sliders are horizontal only.
 *
 * @struct uiSlider
 * @extends uiControl
 * @ingroup dataEntry
 */
Slider :: distinct Control

/**
 * A control that visualizes the progress of a task via the fill level of a horizontal bar.
 *
 * Indeterminate values are supported via an animated bar.
 *
 * @struct uiProgressBar
 * @extends uiControl
 * @ingroup static
 */
ProgressBar :: distinct Control


/**
 * A control to visually separate controls, horizontally or vertically.
 *
 * @struct uiSeparator
 * @extends uiControl
 * @ingroup static
 */
Separator :: distinct Control


/**
 * A control to select one item from a predefined list of items via a drop down menu.
 *
 * @see uiEditableCombobox.
 * @struct uiCombobox
 * @extends uiControl
 * @ingroup dataEntry
 */
Combobox :: distinct Control

/**
 * A control to select one item from a predefined list of items or enter ones own.
 *
 * Predefined items can be selected from a drop down menu.
 *
 * A customary item can be entered by the user via an editable text field.
 *
 * @see uiCombobox
 * @struct uiEditableCombobox
 * @extends uiControl
 * @ingroup dataEntry
 */
EditableCombobox :: distinct Control

/**
 * A multiple choice control of check buttons from which only one can be selected at a time.
 *
 * @struct uiRadioButtons
 * @extends uiControl
 * @ingroup dataEntry
 */
RadioButtons :: distinct Control

/**
 * A control to enter a date and/or time.
 *
 * All functions operate on `struct tm` as defined in `<time.h>`.
 *
 * All functions assume local time and do NOT perform any time zone conversions.
 *
 * @warning The `struct tm` members `tm_wday` and `tm_yday` are undefined.
 * @warning The `struct tm` member `tm_isdst` is ignored on windows and should be set to `-1`.
 *
 * @todo for Time: define what values are returned when a part is missing
 *
 * @struct uiDateTimePicker
 * @extends uiControl
 * @ingroup dataEntry
 */
DateTimePicker :: distinct Control

/**
 * A control with a multi line text entry field.
 *
 * @todo provide a facility for entering tab stops?
 * @struct uiMultilineEntry
 * @extends uiControl
 * @ingroup dataEntry
 */
MultilineEntry :: distinct Control

/**
 * A menu item used in conjunction with uiMenu.
 *
 * @struct uiMenuItem
 * @ingroup static menu
 */
MenuItem :: distinct Control

/**
 * An application level menu bar.
 *
 * The various operating systems impose different requirements on the
 * creation and placement of menu bar items, hence the abstraction of the
 * items `Quit`, `Preferences` and `About`.
 *
 * An exemplary, cross platform menu bar:
 *
 * - File
 *   * New
 *   * Open
 *   * Save
 *   * Quit, _use uiMenuAppendQuitItem()_
 * - Edit
 *   * Undo
 *   * Redo
 *   * Cut
 *   * Copy
 *   * Paste
 *   * Select All
 *   * Preferences, _use uiMenuAppendPreferencesItem()_
 * - Help
 *   * About, _use uiMenuAppendAboutItem()_
 *
 * @struct uiMenu
 * @ingroup static menu
 */
Menu :: distinct Control

AreaHandler :: struct {
	Draw: #type proc(_: ^AreaHandler, __: ^Area, ___: ^AreaDrawParams),
	// NOTE: resizes cause a full redraw for non-scrolling areas, implementation-defined for scrolling areas
	MouseEvent: #type proc(_: ^AreaHandler, __: ^Area, ___: ^AreaMouseEvent),
	// NOTE: on first show if the mouse is already in the uiArea then one gets sent with left=0
	MouseCrossed: #type proc(_: ^AreaHandler, __: ^Area, left: c.int),
	DragBroken: #type proc(_: ^AreaHandler, __: ^Area),
	KeyEvent: #type proc(_: ^AreaHandler, __: ^Area, ___: ^AreaKeyEvent) -> c.int,
}

Area :: distinct Control

AreaDrawParams :: struct {
	Context: ^DrawContext,

	// NOTE: this is only defined for nonscrolling areas
	AreaWidth: f64,
	AreaHeight: f64,

	ClipX: f64,
	ClipY: f64,
	ClipWidth: f64,
	ClipHeight: f64,
}

AreaMouseEvent :: struct {
	X: f64,
	Y: f64,

	AreaWidth: f64,
	AreaHeight: f64,

	Down: c.int,
	Up: c.int,

	Count: c.int,

	Modifiers: Modifiers,

	Held1To64: c.uint64_t,
}

AreaKeyEvent :: struct {
	Key: c.char,
	ExtKey: ExtKey,
	Modifier: Modifiers,

	Modifiers: Modifiers,

	Up: c.int,
}

// TODO: this is forward declared and has platform-specific concrete types
DrawContext :: struct{}

// TODO: this is forward declared and has platform-specific concrete types
DrawPath :: struct{}

DrawBrush :: struct {
	Type: DrawBrushType,

	// solid brushes
	R: f64,
	G: f64,
	B: f64,
	A: f64,

	// gradient brushes
	X0: f64,		// linear: start X, radial: start X
	Y0: f64,		// linear: start Y, radial: start Y
	X1: f64,		// linear: end X, radial: outer circle center X
	Y1: f64,		// linear: end Y, radial: outer circle center Y
	OuterRadius: f64,		// radial gradients only
	Stops: [^]DrawBrushGradientStop,
	NumStops: c.size_t,
}

DrawStrokeParams :: struct {
	Cap: DrawLineCap,
	Join: DrawLineJoin,
	Thickness: f64,
	MiterLimit: f64,
	Dashes: [^]f64,
	NumDashes: c.size_t,
	DashPhase: c.double,
}

DrawMatrix :: struct {
	M11: f64,
	M12: f64,
	M21: f64,
	M22: f64,
	M31: f64,
	M32: f64,
}

DrawBrushGradientStop :: struct {
	Pos: f64,
	R: f64,
	G: f64,
	B: f64,
	A: f64,
}

// uiAttribute stores information about an attribute in a
// uiAttributedString.
//
// You do not create uiAttributes directly; instead, you create a
// uiAttribute of a given type using the specialized constructor
// functions. For every Unicode codepoint in the uiAttributedString,
// at most one value of each attribute type can be applied.
//
// uiAttributes are immutable and the uiAttributedString takes
// ownership of the uiAttribute object once assigned, copying its
// contents as necessary.
#assert(size_of(Attribute) == 64)
Attribute :: struct{
	ownedByUser: c.int,
	refcount: c.size_t,
	type: AttributeType,
	using _: struct #raw_union {
		family: [^]c.char,
		size: f64,
		weight: TextWeight,
		italic: TextItalic,
		stretch: TextStretch,
		color: struct {
			r: f64,
			g: f64,
			b: f64,
			a: f64,
			// put this here so we can reuse this structure
			underlineColor: UnderlineColor,
		},
		underline: Underline,
		features: ^OpenTypeFeatures,
	},
}

// uiOpenTypeFeatures represents a set of OpenType feature
// tag-value pairs, for applying OpenType features to text.
// OpenType feature tags are four-character codes defined by
// OpenType that cover things from design features like small
// caps and swashes to language-specific glyph shapes and
// beyond. Each tag may only appear once in any given
// uiOpenTypeFeatures instance. Each value is a 32-bit integer,
// often used as a Boolean flag, but sometimes as an index to choose
// a glyph shape to use.
//
// If a font does not support a certain feature, that feature will be
// ignored.
//
// See the OpenType specification at
// https://www.microsoft.com/typography/otspec/featuretags.htm
// for the complete list of available features, information on specific
// features, and how to use them.
@(private = "file")
feature :: struct {
	a: c.char,
	b: c.char,
	c_: c.char,
	d: c.char,
	value: c.uint32_t,
}

OpenTypeFeatures :: struct {
	data: ^feature,
	len: c.size_t,
	cap: c.size_t,
}

// uiOpenTypeFeaturesForEachFunc is the type of the function
// invoked by uiOpenTypeFeaturesForEach() for every OpenType
// feature in otf. Refer to that function's documentation for more
// details.
OpenTypeFeaturesForEachFunc :: #type proc(#by_ptr otf: OpenTypeFeatures, a, b, c_, d: c.char, value: c.uint32_t, data: rawptr) -> ForEach

@(private = "file")
attr :: struct {
	val: ^Attribute,
	start: c.size_t,
	end: c.size_t,
	prev: ^attr,
	next: ^attr,
}

@(private = "file")
uiprivAttrList :: struct {
	first: ^attr,
	last: ^attr,
}

@(private = "file")
uiprivGraphemes :: struct {
	len: c.size_t,
	pointsToGraphemes: [^]c.size_t,
	graphemesToPoints: [^]c.size_t,
}

AttributedString :: struct {
	s: [^]c.char,
	len: c.size_t,

	attrs: ^uiprivAttrList,

	// indiscriminately keep a UTF-16 copy of the string on all platforms so we can hand this off to the grapheme calculator
	// this ensures no one platform has a speed advantage (sorry GTK+)
	u16: ^c.uint16_t,
	u16len: c.size_t,

	u8tou16: ^c.size_t,
	u16tou8: ^c.size_t,

	// this is lazily created to keep things from getting *too* slow
	graphemes: ^uiprivGraphemes,
}

// uiAttributedStringForEachAttributeFunc is the type of the function
// invoked by uiAttributedStringForEachAttribute() for every
// attribute in s. Refer to that function's documentation for more
// details.
AttributedStringForEachAttributeFunc :: #type proc(#by_ptr s: AttributedString, #by_ptr a: Attribute, start: c.size_t, end: c.size_t, data: rawptr) -> ForEach

// uiFontDescriptor provides a complete description of a font where
// one is needed. Currently, this means as the default font of a
// uiDrawTextLayout and as the data returned by uiFontButton.
// All the members operate like the respective uiAttributes.
FontDescriptor :: struct {
	Family: [^]c.char,
	Size: f64,
	Weight: TextWeight,
	Italic: TextItalic,
	Stretch: TextStretch,
}

// uiDrawTextLayout is a concrete representation of a
// uiAttributedString that can be displayed in a uiDrawContext.
// It includes information important for the drawing of a block of
// text, including the bounding box to wrap the text within, the
// alignment of lines of text within that box, areas to mark as
// being selected, and other things.
//
// Unlike uiAttributedString, the content of a uiDrawTextLayout is
// immutable once it has been created.
// TODO: opaque struct ??
DrawTextLayout :: struct {}

// uiDrawTextLayoutParams describes a uiDrawTextLayout.
// DefaultFont is used to render any text that is not attributed
// sufficiently in String. Width determines the width of the bounding
// box of the text; the height is determined automatically.
DrawTextLayoutParams :: struct {
	String: ^AttributedString,
	DefaultFont: ^FontDescriptor,
	Width: f64,
	Align: DrawTextAlign,
}

/**
 * A button-like control that opens a font chooser when clicked.
 *
 * @ŧodo SetFont, mechanics
 * @todo Have a function that sets an entire font descriptor to a range in a uiAttributedString at once, for SetFont?
 *
 * @struct uiFontButton
 * @extends uiControl
 * @ingroup button dataEntry
 */
FontButton :: distinct Control

/**
 * A control with a color indicator that opens a color chooser when clicked.
 *
 * The control visually represents a button with a color field representing
 * the selected color.
 *
 * Clicking on the button opens up a color chooser in form of a color palette.
 *
 * @struct uiColorButton
 * @extends uiControl
 * @ingroup dataEntry button
 */
ColorButton :: distinct Control

/**
 * A container control to organize contained controls as labeled fields.
 *
 * As the name suggests this container is perfect to create ascetically pleasing
 * input forms.
 *
 * Each control is preceded by it's corresponding label.
 *
 * Labels and containers are organized into two panes, making both labels
 * and containers align with each other.
 *
 * @struct uiForm
 * @extends uiControl
 * @ingroup container
 */
Form :: distinct Control

/**
 * A control container to arrange containing controls in a grid.
 *
 * Contained controls are arranged on an imaginary grid of rows and columns.
 * Controls can be placed anywhere on this grid, spanning multiple rows and/or
 * columns.
 *
 * Additionally placed controls can be programmed to expand horizontally and/or
 * vertically, sharing the remaining space among other expanded controls.
 *
 * Alignment options are available via @ref uiAlign attributes to determine the
 * controls placement within the reserved area, should the area be bigger than
 * the control itself.
 *
 * Controls can also be placed in relation to other controls using @ref uiAt
 * attributes.
 *
 * @struct uiGrid
 * @extends uiControl
 * @ingroup container
 */
Grid :: distinct Control

/**
 * A container for an image to be displayed on screen.
 *
 * The container can hold multiple representations of the same image with the
 * _same_ aspect ratio but in different resolutions to support high-density
 * displays.
 *
 * Common image dimension scale factors are `1x` and `2x`. Providing higher
 * density representations is entirely optional.
 *
 * The system will automatically determine the correct image to render depending
 * on the screen's pixel density.
 *
 * uiImage only supports premultiplied 32-bit RGBA images.
 *
 * No image file loading or image format conversion utilities are provided.
 *
 * @struct uiImage
 * @ingroup static
 */
// TODO: opaque struct ??
Image :: struct {}

/**
 * @addtogroup table
 * @{
 *
 * Types and methods for organizing and displaying tabular data.
 *
 * Tables follow the concept of separation of concerns, similar to common
 * patterns like model-view-controller or model-view-adapter.
 *
 * They consist of three main components:
 *
 * - uiTableModel acts as a delegate for the underlying data store. Its purpose
 *   is to provide the data for views and inform about any updates.
 * - uiTable represents the view. Its purpose is to display the data provided
 *   by the model as well as provide an interface to the user to modify data.
 * - uiTableModelHandler takes on the role of controller and model. It provides
 *   the actual data while also handling data edits.
 *
 * To get started:
 *
 * 1. Implement all of the methods defined in uiTableModelHandler.
 *    This involves defining columns, their data types as well as getters and
 *    setters for each table cell.
 * 2. Wrap the uiTableModelHandler from step 1 in a uiTableModel object.
 * 3. Create a new uiTable using the model created in step 2.
 *    Start adding columns to your table. Each table column is backed by
 *    one or more model columns.
 *
 * You can create multiple differing views (uiTable) using the same
 * uiTableModel.
 *
 * @}
 */

/**
 * Container to store values used in container related methods.
 *
 * uiTableValue objects are immutable.
 *
 * uiTable and uiTableModel methods take ownership of the uiTableValue objects
 * when passed as parameter. Exception: uiNewTableValueImage().
 *
 * uiTable and uiTableModel methods retain ownership when returning uiTableValue
 * objects. Exception: uiTableValueImage().
 *
 * @struct uiTableValue
 * @ingroup table
 */
// TODO: opaque struct ???
TableValue :: struct {}

/**
 * Table model delegate to retrieve data and inform about model changes.
 *
 * This is a wrapper around uiTableModelHandler where the actual data is
 * held.
 *
 * The main purpose it to provide methods to the developer to signal that
 * underlying data has changed.
 *
 * Row indexes match both the row indexes in uiTable and uiTableModelHandler.
 *
 * A uiTableModel can be used as the backing store for multiple uiTable views.
 *
 * Once created, the number of columns and their data types are not allowed
 * to change.
 *
 * @warning Not informing the uiTableModel about out-of-band data changes is
 *          an error. User edits via uiTable do *not* fall in this category.
 * @struct uiTableModel
 * @ingroup table
 */
 // TODO: opaque struct ???
TableModel :: struct {}

/**
 * Developer defined methods for data retrieval and setting.
 *
 * These methods get called whenever the associated uiTableModel needs to
 * retrieve data or a uiTable wants to set data.
 *
 * @warning These methods are NOT allowed to change as soon as the
 *          uiTableModelHandler is associated with a uiTableModel.
 * @todo Validate ranges
 * @todo Validate types on each getter/setter call (? table columns only?)
 * @struct uiTableModelHandler
 * @ingroup table
 */
TableModelHandler :: struct {
	/**
	 * Returns the number of columns in the uiTableModel.
	 *
	 * @warning This value MUST remain constant throughout the lifetime of the uiTableModel.
	 * @warning This method is not guaranteed to be called depending on the system.
	 * @todo strongly check column numbers and types on all platforms so
	 *       these clauses can go away
	 */
	NumColumns: #type proc(h: ^TableModelHandler, m: ^TableModel) -> c.int,

	/**
	 * Returns the column type in for of a #uiTableValueType.
	 *
	 * @warning This value MUST remain constant throughout the lifetime of the uiTableModel.
	 * @warning This method is not guaranteed to be called depending on the system.
	 */
	ColumnType: #type proc(h: ^TableModelHandler, m: ^TableModel, column: c.int) -> TableValueType,

	/**
	 * Returns the number of rows in the uiTableModel.
	 */
	NumRows: #type proc(h: ^TableModelHandler, m: ^TableModel) -> c.int,

	/**
	 * Returns the cell value for (row, column).
	 *
	 * Make sure to use the uiTableValue constructors. The returned value
	 * must match the #uiTableValueType defined in ColumnType().
	 *
	 * Some columns may return `NULL` as a special value. Refer to the
	 * appropriate `uiTableAppend*Column()` documentation.
	 *
	 * @note uiTableValue objects are automatically freed when requested by
	 *       a uiTable.
	 */
	CellValue: #type proc(mh: ^TableModelHandler, m: ^TableModel, row: c.int, column: c.int) -> ^TableValue,

	/**
	 * Sets the cell value for (row, column).
	 *
	 * It is up to the handler to decide what to do with the value: change
	 * the model or reject the change, keeping the old value.
	 *
	 * Some columns may call this function with `NULL` as a special value.
	 * Refer to the appropriate `uiTableAppend*Column()` documentation.
	 *
	 * @note uiTableValue objects are automatically freed upon return when
	 * set by a uiTable.
	 */
	SetCellValue: #type proc(h: ^TableModelHandler, tm: ^TableModel, _: c.int, __: c.int, #by_ptr tv: TableValue),
}

/**
 * Optional parameters to control the appearance of text columns.
 *
 * @struct uiTableTextColumnOptionalParams
 * @ingroup table
 */
TableTextColumnOptionalParams :: struct {
	/**
	 * uiTableModel column that defines the text color for each cell.
	 *
	 * #uiTableValueTypeColor Text color, `NULL` to use the default color
	 * for that cell.
	 *
	 * `-1` to use the default color for all cells.
	 */
	ColorModelColumn: c.int,
}

/**
 * Table parameters passed to uiNewTable().
 *
 * @struct uiTableParams
 * @ingroup table
 */
TableParams :: struct {
	/**
	 * Model holding the data to be displayed. This can NOT be `NULL`.
	 */
	Model: ^TableModel,
	/**
	 * uiTableModel column that defines background color for each row,
	 *
	 * #uiTableValueTypeColor Background color, `NULL` to use the default
	 * background color for that row.
	 *
	 * `-1` to use the default background color for all rows.
	 */
	RowBackgroundColorModelColumn: c.int,
}

/**
 * A control to display data in a tabular fashion.
 *
 * The view of the architecture.
 *
 * Data is retrieved from a uiTableModel via methods that you need to define
 * in a uiTableModelHandler.
 *
 * Make sure the uiTableModel columns return the right type, as specified in
 * the `uiTableAppend*Column()` parameters.
 *
 * The `*EditableModelColumn` parameters typically point to a uiTableModel
 * column index, that specifies the property on a per row basis.\n
 * They can however also be passed two special values defining the property
 * for all rows: `uiTableModelColumnNeverEditable` and
 * `uiTableModelColumnAlwaysEditable`.
 *
 * @struct uiTable
 * @extends uiControl
 * @ingroup dataEntry table
 */
Table :: distinct Control

/**
 * Holds an array of selected row indices for a table.
 *
 * @struct uiTableSelection
 * @ingroup table
 */
TableSelection :: struct {
	NumRows: c.int, //!< Number of selected rows.
	Rows: [^]c.int,   //!< Array containing selected row indices, NULL on empty selection.
}


@(link_prefix="ui")
foreign libui {
	Init :: proc(options: ^InitOptions) -> cstring ---
	Uninit :: proc() ---
	FreeInitError :: proc(err: cstring) ---

	Main :: proc() ---
	MainSteps :: proc() ---
	MainStep :: proc(wait: c.int) -> c.int ---
	Quit :: proc() ---

	QueueMain :: proc(f: #type proc(data: rawptr), data: rawptr) ---
	
	Timer :: proc(milliseconds: c.int, f: #type proc(data: rawptr) -> c.int, data: rawptr) ---
	OnShouldQuit :: proc(f: #type proc(data: rawptr) -> b32, data: rawptr) ---

	/**
	* Free the memory of a returned string.
	*
	* @note Every time a string is returned from the library, this method should be called.
	*       Examples of these functions are uiWindowTitle, uiOpenFile, uiSaveFile, and uiEntryText.
	*       It is not required for input strings, e.g. in uiWindowSetTitle.
	*
	* @param text The string to free memory
	*/
	FreeText :: proc(text: cstring) ---

	
	/**
	* Dispose and free all allocated resources.
	*
	* The platform specific APIs that actually destroy a control (and its children) are called.
	*
	* @note Most of the time is needed to be used directly only on the top level windows.
	*
	* @param c Control instance.
	* @todo Document ownership.
	* @memberof Control
	*/
	ControlDestroy :: proc(c: ^Control) ---

	/**
	* Returns the control's OS-level handle.
	*
	* @param c Control instance.
	* @returns OS-level handle.
	* @memberof Control
	*/
	ControlHandle :: proc(c_: ^Control) -> c.uintptr_t ---

	/**
	* Returns the parent control.
	*
	* @param c Control instance.
	* @returns The parent control, `NULL` if detached.
	* @memberof Control
	*/
	ControlParent :: proc(c: ^Control) -> ^Control ---

	/**
	* Sets the control's parent.
	*
	* @param c Control instance.
	* @param parent The parent control, `NULL` to detach.
	* @todo Document ownership.
	* @memberof Control
	*/
	ControlSetParent :: proc(c: ^Control, parent: ^Control) ---

	/**
	* Returns whether or not the control is a top level control.
	*
	* @param c Control instance.
	* @returns `TRUE` if top level control, `FALSE` otherwise.
	* @memberof Control
	*/
	ControlToplevel :: proc(c: ^Control) -> b32 ---

	/**
	* Returns whether or not the control is visible.
	*
	* @param c Control instance.
	* @returns `TRUE` if visible, `FALSE` otherwise.
	* @memberof Control
	*/
	ControlVisible :: proc(c: ^Control) -> b32 ---

	/**
	* Shows the control.
	*
	* @param c Control instance.
	* @memberof Control
	*/
	ControlShow :: proc(c: ^Control) ---

	/**
	* Hides the control.
	*
	* @param c Control instance.
	* @note Hidden controls do not take up space within the layout.
	* @memberof Control
	*/
	ControlHide :: proc(c: ^Control) ---

	/**
	* Returns whether or not the control is enabled.
	*
	* Defaults to `true`.
	*
	* @param c Control instance.
	* @see ControlEnabledToUser
	* @memberof Control
	*/
	ControlEnabled :: proc(c_: ^Control) -> c.int ---

	/**
	* Enables the control.
	*
	* @param c Control instance.
	* @memberof Control
	*/
	ControlEnable :: proc(c: ^Control) ---

	/**
	* Disables the control.
	*
	* @param c Control instance.
	* @memberof Control
	*/
	ControlDisable :: proc(c: ^Control) ---

	/**
	* Allocates a Control.
	*
	* Helper to allocate new controls.
	*
	* @param n Size of type to allocate.
	* @todo Document parameters
	* @memberof Control @static
	*/
	AllocControl :: proc(n: c.size_t, OSsig: c.uint32_t, typesig: c.uint32_t, typenamestr: cstring) -> ^Control ---

	/**
	* Frees the memory associated with the control reference.
	*
	* @note This method is public only for writing custom controls.
	*
	* @param c Control instance.
	* @memberof Control
	*/
	FreeControl :: proc(c: ^Control) ---

	/**
	* Makes sure the control's parent can be set to @p parent.
	*
	* @param c Control instance.
	* @param parent Control instance.
	* @todo Make sure all controls have these
	* @warning This will crash the application if `FALSE`.
	* @memberof Control
	*/
	ControlVerifySetParent :: proc(c: ^Control, parent: ^Control) ---

	/**
	* Returns whether or not the control can be interacted with by the user.
	*
	* Checks if the control and all it's parents are enabled to make sure it can
	* be interacted with by the user.
	*
	* @param c Control instance.
	* @returns `TRUE` if enabled, `FALSE` otherwise.
	* @see ControlEnabled
	* @memberof Control
	*/
	ControlEnabledToUser :: proc(c: ^Control) -> b32 ---

	UserBugCannotSetParentOnToplevel :: proc(type: cstring) ---

	/**
	* Returns the window title.
	*
	* @param w uiWindow instance.
	* @returns The window title text.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiWindow
	*/
	WindowTitle :: proc(w: ^Window) -> cstring ---

	/**
	* Sets the window title.
	*
	* @param w uiWindow instance.
	* @param title Window title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @note This method is merely a hint and may be ignored on unix platforms.
	* @memberof uiWindow
	*/
	WindowSetTitle :: proc(w: ^Window, title: cstring) ---

	/**
	* Gets the window position.
	*
	* Coordinates are measured from the top left corner of the screen.
	*
	* @param w uiWindow instance.
	* @param[out] x X position of the window.
	* @param[out] y Y position of the window.
	* @note This method may return inaccurate or dummy values on Unix platforms.
	* @memberof uiWindow
	*/
	WindowPosition :: proc(w: ^Window, x: ^c.int, y: ^c.int) ---

	/**
	* Moves the window to the specified position.
	*
	* Coordinates are measured from the top left corner of the screen.
	*
	* @param w uiWindow instance.
	* @param x New x position of the window.
	* @param y New y position of the window.
	* @note This method is merely a hint and may be ignored on Unix platforms.
	* @memberof uiWindow
	*/
	WindowSetPosition :: proc(w: ^Window, x: c.int, y: c.int) ---

	/**
	* Registers a callback for when the window moved.
	*
	* @param w uiWindow instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.\n
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @note The callback is not triggered when calling uiWindowSetPosition().
	* @memberof uiWindow
	*/
	WindowOnPositionChanged :: proc(w: ^Window, f: #type proc(sender: ^Window, senderData: rawptr), data: rawptr) ---

	/**
	* Gets the window content size.
	*
	* @param w uiWindow instance.
	* @param[out] width Window content width.
	* @param[out] height Window content height.
	* @note The content size does NOT include window decorations like menus or title bars.
	* @memberof uiWindow
	*/
	WindowContentSize :: proc(w: ^Window, width: ^c.int, height: ^c.int) ---

	/**
	* Sets the window content size.
	*
	* @param w uiWindow instance.
	* @param width Window content width to set.
	* @param height Window content height to set.
	* @note The content size does NOT include window decorations like menus or title bars.
	* @note This method is merely a hint and may be ignored by the system.
	* @memberof uiWindow
	*/
	WindowSetContentSize :: proc(w: ^Window, width: c.int, height: c.int) ---

	/**
	* Returns whether or not the window is full screen.
	*
	* @param w uiWindow instance.
	* @returns `TRUE` if full screen, `FALSE` otherwise. [Default: `FALSE`]
	* @memberof uiWindow
	*/
	WindowFullscreen :: proc(w: ^Window) -> b32 ---

	/**
	* Sets whether or not the window is full screen.
	*
	* @param w uiWindow instance.
	* @param fullscreen `TRUE` to make window full screen, `FALSE` otherwise.
	* @note This method is merely a hint and may be ignored by the system.
	* @memberof uiWindow
	*/
	WindowSetFullscreen :: proc(w: ^Window, fullscreen: b32) ---

	/**
	* Registers a callback for when the window content size is changed.
	*
	* @param w uiWindow instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiWindowSetContentSize().
	* @note Only one callback can be registered at a time.
	* @memberof uiWindow
	*/
	WindowOnContentSizeChanged :: proc(w: ^Window, f: #type proc(sender: ^Window, senderData: rawptr), data: rawptr) ---

	/**
	* Registers a callback for when the window is to be closed.
	*
	* @param w uiWindow instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.\n
	*          Return:\n
	*          `TRUE` to destroys the window.\n
	*          `FALSE` to abort closing and keep the window alive and visible.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiWindow
	*/
	WindowOnClosing :: proc(w: ^Window, f: #type proc(sender: ^Window, senderData: rawptr) -> b32, data: rawptr) ---

	/**
	* Registers a callback for when the window focus changes.
	*
	* @param w uiWindow instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiWindow
	*/
	WindowOnFocusChanged :: proc(w: ^Window, f: #type proc(sender: ^Window, senderData: rawptr), data: rawptr) ---

	/**
	* Returns whether or not the window is focused.
	*
	* @param w uiWindow instance.
	* @returns `TRUE` if window is focused, `FALSE` otherwise.
	* @memberof uiWindow
	*/
	WindowFocused :: proc(w: ^Window) -> b32 ---

	/**
	* Returns whether or not the window is borderless.
	*
	* @param w uiWindow instance.
	* @returns `TRUE` if window is borderless, `FALSE` otherwise.
	* @memberof uiWindow
	*/
	WindowBorderless :: proc(w: ^Window) -> b32 ---

	/**
	* Sets whether or not the window is borderless.
	*
	* @param w uiWindow instance.
	* @param borderless `TRUE` to make window borderless, `FALSE` otherwise.
	* @note This method is merely a hint and may be ignored by the system.
	* @memberof uiWindow
	*/
	WindowSetBorderless :: proc(w: ^Window, borderless: b32) ---

	/**
	* Sets the window's child.
	*
	* @param w uiWindow instance.
	* @param child Control to be made child.
	* @memberof uiWindow
	*/
	WindowSetChild :: proc(w: ^Window, child: ^Control) ---

	/**
	* Returns whether or not the window has a margin.
	*
	* @param w uiWindow instance.
	* @returns `TRUE` if window has a margin, `FALSE` otherwise.
	* @memberof uiWindow
	*/
	WindowMargined :: proc(w: ^Window) -> b32 ---

	/**
	* Sets whether or not the window has a margin.
	*
	* The margin size is determined by the OS defaults.
	*
	* @param w uiWindow instance.
	* @param margined `TRUE` to set a window margin, `FALSE` otherwise.
	* @memberof uiWindow
	*/
	WindowSetMargined :: proc(w: ^Window, margined: b32) ---

	/**
	* Returns whether or not the window is user resizeable.
	*
	* @param w uiWindow instance.
	* @returns `TRUE` if window is resizable, `FALSE` otherwise. [Default: `TRUE`]
	* @memberof uiWindow
	*/
	WindowResizeable :: proc(w: ^Window) -> b32 ---

	/**
	* Sets whether or not the window is user resizeable.
	*
	* @param w uiWindow instance.
	* @param resizeable `TRUE` to make window resizable, `FALSE` otherwise.
	* @note This method is merely a hint and may be ignored by the system.
	* @memberof uiWindow
	*/
	WindowSetResizeable :: proc(w: ^Window, resizeable: b32) ---

	/**
	* Creates a new uiWindow.
	*
	* @param title Window title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @param width Window width.
	* @param height Window height.
	* @param hasMenubar Whether or not the window should display a menu bar.
	* @returns A new uiWindow instance.
	* @memberof uiWindow @static
	*/
	NewWindow :: proc(title: cstring, width: c.int, height: c.int, hasMenubar: b32) -> ^Window ---

	/**
	* Returns the button label text.
	*
	* @param b uiButton instance.
	* @returns The text of the label.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiButton
	*/
	ButtonText :: proc(b: ^Button) -> cstring ---

	/**
	* Sets the button label text.
	*
	* @param b uiButton instance.
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiButton
	*/
	ButtonSetText :: proc(b: ^Button, text: cstring) ---

	/**
	* Registers a callback for when the button is clicked.
	*
	* @param b uiButton instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiButton
	*/
	ButtonOnClicked :: proc(b: ^Button, f: #type proc(sender: ^Button, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new button.
	*
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiButton instance.
	* @memberof uiButton @static
	*/
	NewButton :: proc(text: cstring) -> ^Button ---

	/**
	* Appends a control to the box.
	*
	* Stretchy items expand to use the remaining space within the box.
	* In the case of multiple stretchy items the space is shared equally.
	*
	* @param b uiBox instance.
	* @param child Control instance to append.
	* @param stretchy `TRUE` to stretch control, `FALSE` otherwise.
	* @memberof uiBox
	*/
	BoxAppend :: proc(b: ^Box, child: ^Control, stretchy: b32) ---

	/**
	* Returns the number of controls contained within the box.
	*
	* @param b uiBox instance.
	* @returns Number of children.
	* @memberof uiBox
	*/
	BoxNumChildren :: proc(b: ^Box) -> c.int ---

	/**
	* Removes the control at @p index from the box.
	*
	* @param b uiBox instance.
	* @param index Index of control to be removed.
	* @note The control neither destroyed nor freed.
	* @memberof uiBox
	*/
	BoxDelete :: proc(b: ^Box, index: c.int) ---

	/**
	* Returns whether or not controls within the box are padded.
	*
	* Padding is defined as space between individual controls.
	*
	* @param b uiBox instance.
	* @returns `TRUE` if controls are padded, `FALSE` otherwise.
	* @memberof uiBox
	*/
	BoxPadded :: proc(b: ^Box) -> b32 ---

	/**
	* Sets whether or not controls within the box are padded.
	*
	* Padding is defined as space between individual controls.
	* The padding size is determined by the OS defaults.
	*
	* @param b uiBox instance.
	* @param padded  `TRUE` to make controls padded, `FALSE` otherwise.
	* @memberof uiBox
	*/
	BoxSetPadded :: proc(b: ^Box, padded: b32) ---

	/**
	* Creates a new horizontal box.
	*
	* Controls within the box are placed next to each other horizontally.
	*
	* @returns A new uiBox instance.
	* @memberof uiBox @static
	*/
	NewHorizontalBox :: proc() -> ^Box ---

	/**
	* Creates a new vertical box.
	*
	* Controls within the box are placed next to each other vertically.
	*
	* @returns A new uiBox instance.
	* @memberof uiBox @static
	*/
	NewVerticalBox :: proc() -> ^Box ---

	/**
	* Returns the checkbox label text.
	*
	* @param c uiCheckbox instance.
	* @returns The text of the label.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiCheckbox
	*/
	CheckboxText :: proc(c: ^Checkbox) -> cstring ---

	/**
	* Sets the checkbox label text.
	*
	* @param c uiCheckbox instance.
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiCheckbox
	*/
	CheckboxSetText :: proc(c: ^Checkbox, text: cstring) ---

	/**
	* Registers a callback for when the checkbox is toggled by the user.
	*
	* @param c uiCheckbox instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that initiated the callback.\n
	*          @p senderData User data registered with the sender instance.\n
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiCheckboxSetChecked().
	* @note Only one callback can be registered at a time.
	* @memberof uiCheckbox
	*/
	CheckboxOnToggled :: proc(c: ^Checkbox, f: #type proc(sender: ^Checkbox, senderData: rawptr), data: rawptr) ---

	/**
	* Returns whether or the checkbox is checked.
	*
	* @param c uiCheckbox instance.
	* @returns `TRUE` if checked, `FALSE` otherwise. [Default: `FALSE`]
	* @memberof uiCheckbox
	*/
	CheckboxChecked :: proc(c: ^Checkbox) -> b32 ---

	/**
	* Sets whether or not the checkbox is checked.
	*
	* @param c uiCheckbox instance.
	* @param checked `TRUE` to check box, `FALSE` otherwise.
	* @memberof uiCheckbox
	*/
	CheckboxSetChecked :: proc(c: ^Checkbox, checked: b32) ---

	/**
	* Creates a new checkbox.
	*
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiCheckbox instance.
	* @memberof uiCheckbox @static
	*/
	NewCheckbox :: proc(text: cstring) -> ^Checkbox ---

	/**
	* Returns the entry's text.
	*
	* @param e uiEntry instance.
	* @returns The text of the entry.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiEntry
	*/
	EntryText :: proc(e: ^Entry) -> cstring ---

	/**
	* Sets the entry's text.
	*
	* @param e uiEntry instance.
	* @param text Entry text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiEntry
	*/
	EntrySetText :: proc(e: ^Entry, text: cstring) ---

	/**
	* Registers a callback for when the user changes the entry's text.
	*
	* @param e uiEntry instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that initiated the callback.\n
	*          @p senderData User data registered with the sender instance.\n
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiEntrySetText().
	* @memberof uiEntry
	*/
	EntryOnChanged :: proc(e: ^Entry, f: #type proc(sender: ^Entry, senderData: rawptr), data: rawptr) ---

	/**
	* Returns whether or not the entry's text can be changed.
	*
	* @param e uiEntry instance.
	* @returns `TRUE` if read only, `FALSE` otherwise. [Default: `FALSE`]
	* @memberof uiEntry
	*/
	EntryReadOnly :: proc(e: ^Entry) -> b32 ---

	/**
	* Sets whether or not the entry's text is read only.
	*
	* @param e uiEntry instance.
	* @param readonly `TRUE` to make read only, `FALSE` otherwise.
	* @memberof uiEntry
	*/
	EntrySetReadOnly :: proc(e: ^Entry, readonly: b32) ---

	/**
	* Creates a new entry.
	*
	* @returns A new uiEntry instance.
	* @memberof uiEntry @static
	*/
	NewEntry :: proc() -> ^Entry ---

	/**
	* Creates a new entry suitable for sensitive inputs like passwords.
	*
	* The entered text is NOT readable by the user but masked as *******.
	*
	* @returns A new uiEntry instance.
	* @memberof uiEntry @static
	*/
	NewPasswordEntry :: proc() -> ^Entry ---

	/**
	* Creates a new entry suitable for search.
	*
	* Some systems will deliberately delay the uiEntryOnChanged() callback for
	* a more natural feel.
	*
	* @returns A new uiEntry instance.
	* @memberof uiEntry @static
	*/
	NewSearchEntry :: proc() -> ^Entry ---

	/**
	* Returns the label text.
	*
	* @param l uiLabel instance.
	* @returns The text of the label.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiLabel
	*/
	LabelText :: proc(l: ^Label) -> cstring ---

	/**
	* Sets the label text.
	*
	* @param l uiLabel instance.
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiLabel
	*/
	LabelSetText :: proc(l: ^Label, text: cstring) ---

	/**
	* Creates a new label.
	*
	* @param text Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiLabel instance.
	* @memberof uiLabel @static
	*/
	NewLabel :: proc(text: cstring) -> ^Label ---

	/**
	* Appends a control in form of a page/tab with label.
	*
	* @param t uiTab instance.
	* @param name Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param c Control to append.
	* @memberof uiTab
	*/
	TabAppend :: proc(t: ^Tab, name: cstring, c: ^Control) ---

	/**
	* Inserts a control in form of a page/tab with label at @p index.
	*
	* @param t uiTab instance.
	* @param name Label text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param index Index at which to insert the control.
	* @param c Control to insert.
	* @memberof uiTab
	*/
	TabInsertAt :: proc(t: ^Tab, name: cstring, index: c.int, c: ^Control) ---

	/**
	* Removes the control at @p index.
	*
	* @param t uiTab instance.
	* @param index Index of the control to be removed.
	* @note The control is neither destroyed nor freed.
	* @memberof uiTab
	*/
	TabDelete :: proc(t: ^Tab, index: c.int) ---

	/**
	* Returns the number of pages contained.
	*
	* @param t uiTab instance.
	* @returns Number of pages.
	* @memberof uiTab
	*/
	TabNumPages :: proc(t: ^Tab) -> c.int ---

	/**
	* Returns whether or not the page/tab at @p index has a margin.
	*
	* @param t uiTab instance.
	* @param index Index to check if it has a margin.
	* @returns `TRUE` if the tab has a margin, `FALSE` otherwise.
	* @memberof uiTab
	*/
	TabMargined :: proc(t: ^Tab, index: c.int) -> b32 ---

	/**
	* Sets whether or not the page/tab at @p index has a margin.
	*
	* The margin size is determined by the OS defaults.
	*
	* @param t uiTab instance.
	* @param index Index of the tab/page to un/set margin for.
	* @param margined `TRUE` to set a margin for tab at @p index, `FALSE` otherwise.
	* @memberof uiTab
	*/
	TabSetMargined :: proc(t: ^Tab, index: c.int, margined: b32) ---

	/**
	* Creates a new tab container.
	*
	* @return A new uiTab instance.
	* @memberof uiTab @static
	*/
	NewTab :: proc() -> ^Tab ---

	/**
	* Returns the group title.
	*
	* @param g uiGroup instance.
	* @returns The group title text.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiGroup
	*/
	GroupTitle :: proc(g: ^Group) -> cstring ---

	/**
	* Sets the group title.
	*
	* @param g uiGroup instance.
	* @param title Group title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @memberof uiGroup
	*/
	GroupSetTitle :: proc(g: ^Group, title: cstring) ---

	/**
	* Sets the group's child.
	*
	* @param g uiGroup instance.
	* @param c uiControl child instance, or `NULL`.
	* @memberof uiGroup
	*/
	GroupSetChild :: proc(g: ^Group, c: ^Control) ---

	/**
	* Returns whether or not the group has a margin.
	*
	* @param g uiGroup instance.
	* @returns `TRUE` if the group has a margin, `FALSE` otherwise.
	* @memberof uiGroup
	*/
	GroupMargined :: proc(g: ^Group) -> b32 ---

	/**
	* Sets whether or not the group has a margin.
	*
	* The margin size is determined by the OS defaults.
	*
	* @param g uiGroup instance.
	* @param margined `TRUE` to set a margin, `FALSE` otherwise.
	* @memberof uiGroup
	*/
	GroupSetMargined :: proc(g: ^Group, margined: b32) ---

	/**
	* Creates a new group.
	*
	* @param title Group title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @returns A new uiGroup instance.
	* @memberof uiGroup @static
	*/
	NewGroup :: proc(title: cstring) -> ^Group ---

	/**
	* Returns the spinbox value.
	*
	* @param s uiSpinbox instance.
	* @returns Spinbox value.
	* @memberof uiSpinbox
	*/
	SpinboxValue :: proc(s: ^Spinbox) -> c.int ---

	/**
	* Sets the spinbox value.
	*
	* @param s uiSpinbox instance.
	* @param value Value to set.
	* @note Setting a value out of range will clamp to the nearest value in range.
	* @memberof uiSpinbox
	*/
	SpinboxSetValue :: proc(s: ^Spinbox, value: c.int) ---

	/**
	* Registers a callback for when the spinbox value is changed by the user.
	*
	* @param s uiSpinbox instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiSpinboxSetValue().
	* @note Only one callback can be registered at a time.
	* @memberof uiSpinbox
	*/
	SpinboxOnChanged :: proc(s: ^Spinbox, f: #type proc(sender: ^Spinbox, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new spinbox.
	*
	* The initial spinbox value equals the minimum value.
	*
	* In the current implementation @p min and @p max are swapped if `min>max`.
	* This may change in the future though. See TODO.
	*
	* @param min Minimum value.
	* @param max Maximum value.
	* @returns A new uiSpinbox instance.
	* @todo complain or disallow min>max?
	* @memberof uiSpinbox @static
	*/
	NewSpinbox :: proc(min: c.int, max: c.int) -> ^Spinbox ---

	/**
	* Returns the slider value.
	*
	* @param s uiSlider instance.
	* @returns Slider value.
	* @memberof uiSlider
	*/
	SliderValue :: proc(s: ^Slider) -> c.int ---

	/**
	* Sets the slider value.
	*
	* @param s uiSlider intance.
	* @param value Value to set.
	* @memberof uiSlider
	*/
	SliderSetValue :: proc(s: ^Slider, value: c.int) ---

	/**
	* Returns whether or not the slider has a tool tip.
	*
	* @param s uiSlider instance.
	* @returns `TRUE` if a tool tip is present, `FALSE` otherwise. [Default `TRUE`]
	* @memberof uiSlider
	*/
	SliderHasToolTip :: proc(s: ^Slider) -> b32 ---

	/**
	* Sets whether or not the slider has a tool tip.
	*
	* @param s uiSlider instance.
	* @param hasToolTip `TRUE` to display a tool tip, `FALSE` to display no tool tip.
	* @memberof uiSlider
	*/
	SliderSetHasToolTip :: proc(s: ^Slider, hasToolTip: b32) ---

	/**
	* Registers a callback for when the slider value is changed by the user.
	*
	* @param s uiSlider instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiSliderSetValue().
	* @note Only one callback can be registered at a time.
	* @memberof uiSlider
	*/
	SliderOnChanged :: proc(s: ^Slider, f: #type proc(sender: ^Slider, senderData: rawptr), data: rawptr) ---

	/**
	* Registers a callback for when the slider is released from dragging.
	*
	* @param s uiSlider instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiSlider
	*/
	SliderOnReleased :: proc(s: ^Slider, f: #type proc(sender: ^Slider, senderData: rawptr), data: rawptr) ---

	/**
	* Sets the slider range.
	*
	* @param s uiSlider instance.
	* @param min Minimum value.
	* @param max Maximum value.
	* @todo Make sure to clamp the slider value to the nearest value in range - should
	*       it be out of range. Call uiSliderOnChanged() in such a case.
	* @memberof uiSlider
	*/
	SliderSetRange :: proc(s: ^Slider, min: c.int, max: c.int) ---

	/**
	* Creates a new slider.
	*
	* The initial slider value equals the minimum value.
	*
	* In the current implementation @p min and @p max are swapped if `min>max`.
	* This may change in the future though. See TODO.
	*
	* @param min Minimum value.
	* @param max Maximum value.
	* @returns A new uiSlider instance.
	* @todo complain or disallow min>max?
	* @memberof uiSlider @static
	*/
	NewSlider :: proc(min: c.int, max: c.int) -> ^Slider ---

	
	/**
	* Returns the progress bar value.
	*
	* @param p uiProgressBar instance.
	* @returns Progress bar value. `[Default 0]`
	* @memberof uiProgressBar
	*/
	ProgressBarValue :: proc(p: ^ProgressBar) -> c.int ---

	/**
	* Sets the progress bar value.
	*
	* Valid values are `[0, 100]` for displaying a solid bar imitating a percent
	* value.
	*
	* Use a value of `-1` to render an animated bar to convey an indeterminate
	* value.
	*
	* @param p uiProgressBar instance.
	* @param n Value to set. Integer in the range of `[-1, 100]`.
	* @memberof uiProgressBar
	*/
	ProgressBarSetValue :: proc(p: ^ProgressBar, n: c.int) ---

	/**
	* Creates a new progress bar.
	*
	* @returns A new uiProgressBar instance.
	* @memberof uiProgressBar @static
	*/
	NewProgressBar :: proc() -> ^ProgressBar ---

	/**
	* Creates a new horizontal separator to separate controls being stacked vertically.
	*
	* @returns A new uiSeparator instance.
	* @memberof uiSeparator @static
	*/
	NewHorizontalSeparator :: proc() -> ^Separator ---

	/**
	* Creates a new vertical separator to separate controls being stacked horizontally.
	*
	* @returns A new uiSeparator instance.
	* @memberof uiSeparator @static
	*/
	NewVerticalSeparator :: proc() -> ^Separator ---

	/**
	* Appends an item to the combo box.
	*
	* @param c uiCombobox instance.
	* @param text Item text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiCombobox
	*/
	ComboboxAppend :: proc(c: ^Combobox, text: cstring) ---

	/**
	* Inserts an item at @p index to the combo box.
	*
	* @param c uiCombobox instance.
	* @param index Index at which to insert the item.
	* @param text Item text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiCombobox
	*/
	ComboboxInsertAt :: proc(c_: ^Combobox, index: c.int, text: cstring) ---

	/**
	* Deletes an item at @p index from the combo box.
	*
	* @note Deleting the index of the item currently selected will move the
	* selection to the next item in the combo box or `-1` if no such item exists.
	*
	* @param c uiCombobox instance.
	* @param index Index of the item to be deleted.
	* @memberof uiCombobox
	*/
	ComboboxDelete :: proc(c_: ^Combobox, index: c.int) ---

	/**
	* Deletes all items from the combo box.
	*
	* @param c uiCombobox instance.
	* @memberof uiCombobox
	*/
	ComboboxClear :: proc(c: ^Combobox) ---

	/**
	* Returns the number of items contained within the combo box.
	*
	* @param c uiCombobox instance.
	* @returns Number of items.
	* @memberof uiCombobox
	*/
	ComboboxNumItems :: proc(c_: ^Combobox) -> c.int ---

	/**
	* Returns the index of the item selected.
	*
	* @param c uiCombobox instance.
	* @returns Index of the item selected, `-1` on empty selection. [Default `-1`]
	* @memberof uiCombobox
	*/
	ComboboxSelected :: proc(c_: ^Combobox) -> c.int ---

	/**
	* Sets the item selected.
	*
	* @param c uiCombobox instance.
	* @param index Index of the item to be selected, `-1` to clear selection.
	* @memberof uiCombobox
	*/
	ComboboxSetSelected :: proc(c_: ^Combobox, index: c.int) ---

	/**
	* Registers a callback for when a combo box item is selected.
	*
	* @param c uiCombobox instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiComboboxSetSelected(),
	*       uiComboboxInsertAt(), uiComboboxDelete(), or uiComboboxClear().
	* @note Only one callback can be registered at a time.
	* @memberof uiCombobox
	*/
	ComboboxOnSelected :: proc(c: ^Combobox, f: #type proc(sender: ^Combobox, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new combo box.
	*
	* @returns A new uiCombobox instance.
	* @memberof uiCombobox @static
	*/
	NewCombobox :: proc() -> ^Combobox ---

	/**
	* Appends an item to the editable combo box.
	*
	* @param c uiEditableCombobox instance.
	* @param text Item text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiEditableCombobox
	*/
	EditableComboboxAppend :: proc(c: ^EditableCombobox, text: cstring) ---

	/**
	* Returns the text of the editable combo box.
	*
	* This text is either the text of one of the predefined list items or the
	* text manually entered by the user.
	*
	* @param c uiEditableCombobox instance.
	* @returns The editable combo box text.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiEditableCombobox
	*/
	EditableComboboxText :: proc(c: ^EditableCombobox) -> cstring ---

	/**
	* Sets the editable combo box text.
	*
	* @param c uiEditableCombobox instance.
	* @param text Text field text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiEditableCombobox
	*/
	EditableComboboxSetText :: proc(c: ^EditableCombobox, text: cstring) ---

	/**
	* Registers a callback for when an editable combo box item is selected or user text changed.
	*
	* @param c uiEditableCombobox instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiEditableComboboxSetText().
	* @note Only one callback can be registered at a time.
	* @memberof uiEditableCombobox
	*/
	EditableComboboxOnChanged :: proc(c: ^EditableCombobox, f: #type proc(sender: ^EditableCombobox, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new editable combo box.
	*
	* @returns A new uiEditableCombobox instance.
	* @memberof uiEditableCombobox @static
	*/
	NewEditableCombobox :: proc() -> ^EditableCombobox ---

	/**
	* Appends a radio button.
	*
	* @param r uiRadioButtons instance.
	* @param text Radio button text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiRadioButtons
	*/
	RadioButtonsAppend :: proc(r: ^RadioButtons, text: cstring) ---

	/**
	* Returns the index of the item selected.
	*
	* @param r uiRadioButtons instance.
	* @returns Index of the item selected, `-1` on empty selection.
	* @memberof uiRadioButtons
	*/
	RadioButtonsSelected :: proc(r: ^RadioButtons) -> c.int ---

	/**
	* Sets the item selected.
	*
	* @param r uiRadioButtons instance.
	* @param index Index of the item to be selected, `-1` to clear selection.
	* @memberof uiRadioButtons
	*/
	RadioButtonsSetSelected :: proc(r: ^RadioButtons, index: c.int) ---

	/**
	* Registers a callback for when radio button is selected.
	*
	* @param r uiRadioButtons instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiRadioButtonsSetSelected().
	* @note Only one callback can be registered at a time.
	* @memberof uiRadioButtons
	*/
	RadioButtonsOnSelected :: proc(r: ^RadioButtons, f: #type proc(sender: ^RadioButtons, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new radio buttons instance.
	*
	* @returns A new uiRadioButtons instance.
	* @memberof uiRadioButtons @static
	*/
	NewRadioButtons :: proc() -> ^RadioButtons ---

	/**
	* Returns date and time stored in the data time picker.
	*
	* @param d uiDateTimePicker instance.
	* @param[out] time Date and/or time as local time.
	* @warning The `struct tm` members `tm_wday` and `tm_yday` are undefined.
	* @memberof uiDateTimePicker
	*/
	DateTimePickerTime :: proc(d: ^DateTimePicker, time: ^libc.tm) ---

	/**
	* Sets date and time of the data time picker.
	*
	*
	* @param d uiDateTimePicker instance.
	* @param time Date and/or time as local time.
	* @warning The `struct tm` member `tm_isdst` is ignored on windows and should be set to `-1`.
	* @memberof uiDateTimePicker
	*/
	DateTimePickerSetTime :: proc(d: ^DateTimePicker, #by_ptr time: libc.tm) ---

	/**
	* Registers a callback for when the date time picker value is changed by the user.
	*
	* @param d uiDateTimePicker instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling  uiDateTimePickerSetTime().
	* @note Only one callback can be registered at a time.
	* @memberof uiDateTimePicker
	*/
	DateTimePickerOnChanged :: proc(d: ^DateTimePicker, f: #type proc(sender: ^DateTimePicker, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new date picker.
	*
	* @returns A new uiDateTimePicker instance.
	* @memberof uiDateTimePicker @static
	*/
	NewDateTimePicker :: proc() -> ^DateTimePicker ---

	/**
	* Creates a new time picker.
	*
	* @returns A new uiDateTimePicker instance.
	* @memberof uiDateTimePicker @static
	*/
	NewDatePicker :: proc() -> ^DateTimePicker ---

	/**
	* Creates a new date and time picker.
	*
	* @returns A new uiDateTimePicker instance.
	* @memberof uiDateTimePicker @static
	*/
	NewTimePicker :: proc() -> ^DateTimePicker ---

	
	/**
	* Returns the multi line entry's text.
	*
	* @param e uiMultilineEntry instance.
	* @returns The containing text.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @memberof uiMultilineEntry
	*/
	MultilineEntryText :: proc(e: ^MultilineEntry) -> cstring ---

	/**
	* Sets the multi line entry's text.
	*
	* @param e uiMultilineEntry instance.
	* @param text Single/multi line text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiMultilineEntry
	*/
	MultilineEntrySetText :: proc(e: ^MultilineEntry, text: cstring) ---

	/**
	* Appends text to the multi line entry's text.
	*
	* @param e uiMultilineEntry instance.
	* @param text Text to append.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @memberof uiMultilineEntry
	*/
	MultilineEntryAppend :: proc(e: ^MultilineEntry, text: cstring) ---

	/**
	* Registers a callback for when the user changes the multi line entry's text.
	*
	* @param e uiMultilineEntry instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that initiated the callback.\n
	*          @p senderData User data registered with the sender instance.\n
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiMultilineEntrySetText()
	*       or uiMultilineEntryAppend().
	* @note Only one callback can be registered at a time.
	* @memberof uiMultilineEntry
	*/
	MultilineEntryOnChanged :: proc(e: ^MultilineEntry, f: #type proc(sender: ^MultilineEntry, senderData: rawptr), data: rawptr) ---

	/**
	* Returns whether or not the multi line entry's text can be changed.
	*
	* @param e uiMultilineEntry instance.
	* @returns `TRUE` if read only, `FALSE` otherwise. [Default: `FALSE`]
	* @memberof uiMultilineEntry
	*/
	MultilineEntryReadOnly :: proc(e: ^MultilineEntry) -> b32 ---

	/**
	* Sets whether or not the multi line entry's text is read only.
	*
	* @param e uiMultilineEntry instance.
	* @param readonly `TRUE` to make read only, `FALSE` otherwise.
	* @memberof uiMultilineEntry
	*/
	MultilineEntrySetReadOnly :: proc(e: ^MultilineEntry, readonly: b32) ---

	/**
	* Creates a new multi line entry that visually wraps text when lines overflow.
	*
	* @returns A new uiMultilineEntry instance.
	* @memberof uiMultilineEntry @static
	*/
	NewMultilineEntry :: proc() -> ^MultilineEntry ---

	/**
	* Creates a new multi line entry that scrolls horizontally when lines overflow.
	*
	* @remark Windows does not allow for this style to be changed after creation,
	*         hence the two constructors.
	* @returns A new uiMultilineEntry instance.
	* @memberof uiMultilineEntry @static
	*/
	NewNonWrappingMultilineEntry :: proc() -> ^MultilineEntry ---

	/**
	* Enables the menu item.
	*
	* @param m uiMenuItem instance.
	* @memberof uiMenuItem
	*/
	MenuItemEnable :: proc(m: ^MenuItem) ---

	/**
	* Disables the menu item.
	*
	* Menu item is grayed out and user interaction is not possible.
	*
	* @param m uiMenuItem instance.
	* @memberof uiMenuItem
	*/
	MenuItemDisable :: proc(m: ^MenuItem) ---

	/**
	* Registers a callback for when the menu item is clicked.
	*
	* @param m uiMenuItem instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p window Reference to the window from which the callback got triggered.\
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiMenuItem
	*/
	MenuItemOnClicked :: proc(m: ^MenuItem, f: #type proc(sender: ^MenuItem, window: ^Window, senderData: rawptr), data: rawptr) ---

	/**
	* Returns whether or not the menu item's checkbox is checked.
	*
	* To be used only with items created via uiMenuAppendCheckItem().
	*
	* @param m uiMenuItem instance.
	* @returns `TRUE` if checked, `FALSE` otherwise. [Default: `FALSE`]
	* @memberof uiMenuItem
	*/
	MenuItemChecked :: proc(m: ^MenuItem) -> b32 ---

	/**
	* Sets whether or not the menu item's checkbox is checked.
	*
	* To be used only with items created via uiMenuAppendCheckItem().
	*
	* @param m uiMenuItem instance.
	* @param checked `TRUE` to check menu item checkbox, `FALSE` otherwise.
	* @memberof uiMenuItem
	*/
	MenuItemSetChecked :: proc(m: ^MenuItem, checked: b32) ---

	/**
	* Appends a generic menu item.
	*
	* @param m uiMenu instance.
	* @param name Menu item text.\n
	*             A `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiMenuItem instance.
	* @memberof uiMenu
	*/
	MenuAppendItem :: proc(m: ^Menu, name: cstring) -> ^MenuItem ---

	/**
	* Appends a generic menu item with a checkbox.
	*
	* @param m uiMenu instance.
	* @param name Menu item text.\n
	*             A `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiMenuItem instance.
	* @memberof uiMenu
	*/
	MenuAppendCheckItem :: proc(m: ^Menu, name: cstring) -> ^MenuItem ---

	/**
	* Appends a new `Quit` menu item.
	*
	* @param m uiMenu instance.
	* @returns A new uiMenuItem instance.
	* @warning Only one such menu item may exist per application.
	* @memberof uiMenu
	*/
	MenuAppendQuitItem :: proc(m: ^Menu) -> ^MenuItem ---

	/**
	* Appends a new `Preferences` menu item.
	*
	* @param m uiMenu instance.
	* @returns A new uiMenuItem instance.
	* @warning Only one such menu item may exist per application.
	* @memberof uiMenu
	*/
	MenuAppendPreferencesItem :: proc(m: ^Menu) -> ^MenuItem ---

	/**
	* Appends a new `About` menu item.
	*
	* @param m uiMenu instance.
	* @warning Only one such menu item may exist per application.
	* @returns A new uiMenuItem instance.
	* @memberof uiMenu
	*/
	MenuAppendAboutItem :: proc(m: ^Menu) -> ^MenuItem ---

	/**
	* Appends a new separator.
	*
	* @param m uiMenu instance.
	* @memberof uiMenu
	*/
	MenuAppendSeparator :: proc(m: ^Menu) ---

	/**
	* Creates a new menu.
	*
	* Typical values are `File`, `Edit`, `Help`.
	*
	* @param name Menu label.\n
	*             A `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @returns A new uiMenu instance.
	* @memberof uiMenu @static
	*/
	NewMenu :: proc(name: cstring) -> ^Menu ---


	/**
	* File chooser dialog window to select a single file.
	*
	* @param parent Parent window.
	* @returns File path, `NULL` on cancel.\n
	*          If path is not `NULL`:\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @note File paths are separated by the underlying OS file path separator.
	* @ingroup dataEntry dialogWindow
	*/
	OpenFile :: proc(parent: ^Window) -> cstring ---

	/**
	* Folder chooser dialog window to select a single folder.
	*
	* @param parent Parent window.
	* @returns Folder path, `NULL` on cancel.\n
	*          If path is not `NULL`:\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @note File paths are separated by the underlying OS file path separator.
	* @ingroup dataEntry dialogWindow
	*/
	OpenFolder :: proc(parent: ^Window) -> cstring ---

	/**
	* Save file dialog window.
	*
	* The user is asked to confirm overwriting existing files, should the chosen
	* file path already exist on the system.
	*
	* @param parent Parent window.
	* @returns File path, `NULL` on cancel.\n
	*          If path is not `NULL`:\n
	*          Caller is responsible for freeing the data with `uiFreeText()`.
	* @note File paths are separated by the underlying OS file path separator.
	* @ingroup dataEntry dialogWindow
	*/
	SaveFile :: proc(parent: ^Window) -> cstring ---

	/**
	* Message box dialog window.
	*
	* A message box displayed in a new window indicating a common message.
	*
	* @param parent Parent window.
	* @param title Dialog window title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @param description Dialog message text.\n
	*                    A valid, `NUL` terminated UTF-8 string.\n
	*                    Data is copied internally. Ownership is not transferred.
	* @ingroup dialogWindow
	*/
	MsgBox :: proc(parent: ^Window, title: cstring, description: cstring) ---

	/**
	* Error message box dialog window.
	*
	* A message box displayed in a new window indicating an error. On some systems
	* this may invoke an accompanying sound.
	*
	* @param parent Parent window.
	* @param title Dialog window title text.\n
	*              A valid, `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @param description Dialog message text.\n
	*                    A valid, `NUL` terminated UTF-8 string.\n
	*                    Data is copied internally. Ownership is not transferred.
	* @ingroup dialogWindow
	*/
	MsgBoxError :: proc(parent: ^Window, title: cstring, description: cstring) ---

	AreaSetSize :: proc(a: ^Area, width: c.int, height: c.int) ---
	AreaQueueRedrawAll :: proc(a: ^Area) ---
	AreaScrollTo :: proc(a: ^Area, x: f64, y: f64, width: f64, height: f64) ---
	AreaBeginUserWindowMove :: proc(a: ^Area) ---
	AreaBeginUserWindowResize :: proc(a: ^Area, edge: WindowResizeEdge) ---
	NewArea :: proc(ah: ^AreaHandler) -> ^Area ---
	NewScrollingArea :: proc(ah: ^AreaHandler, width: c.int, height: c.int) -> ^Area ---

	DrawNewPath :: proc(fillMode: DrawFillMode) -> ^DrawPath ---
	DrawFreePath :: proc(p: ^DrawPath) ---

	DrawPathNewFigure :: proc(p: ^DrawPath, x: f64, y: f64) ---
	DrawPathNewFigureWithArc :: proc(p: ^DrawPath, xCenter: f64, yCenter: f64, radius: f64, startAngle: f64, sweep: f64, negative: c.int) ---
	DrawPathLineTo :: proc(p: ^DrawPath, x: f64, y: f64) ---
	// notes: angles are both relative to 0 and go counterclockwise
	DrawPathArcTo :: proc(p: ^DrawPath, xCenter: f64, yCenter: f64, radius: f64, startAngle: f64, sweep: f64, negative: c.int) ---
	DrawPathBezierTo :: proc(p: ^DrawPath, c1x: f64, c1y: f64, c2x: f64, c2y: f64, endX: f64, endY: f64) ---
	DrawPathCloseFigure :: proc(p: ^DrawPath) ---

	DrawPathAddRectangle :: proc(p: ^DrawPath, x: f64, y: f64, width: f64, height: f64) ---

	DrawPathEnded :: proc(p: ^DrawPath) -> c.int ---
	DrawPathEnd :: proc(p: ^DrawPath) ---

	DrawStroke :: proc(c: ^DrawContext, path: ^DrawPath, b: ^DrawBrush, p: ^DrawStrokeParams) ---
	DrawFill :: proc(c: ^DrawContext, path: ^DrawPath, b: ^DrawBrush) ---

	DrawMatrixSetIdentity :: proc(m: ^DrawMatrix) ---
	DrawMatrixTranslate :: proc(m: ^DrawMatrix, x: f64, y: f64) ---
	DrawMatrixScale :: proc(m: ^DrawMatrix, xCenter: f64, yCenter: f64, x: f64, y: f64) ---
	DrawMatrixRotate :: proc(m: ^DrawMatrix, x: f64, y: f64, amount: f64) ---
	DrawMatrixSkew :: proc(m: ^DrawMatrix, x: f64, y: f64, xamount: f64, yamount: f64) ---
	DrawMatrixMultiply :: proc(dest: ^DrawMatrix, src: ^DrawMatrix) ---
	DrawMatrixInvertible :: proc(uim: ^DrawMatrix) -> c.int ---
	DrawMatrixInvert :: proc(uim: ^DrawMatrix) -> c.int ---
	DrawMatrixTransformPoint :: proc(m: ^DrawMatrix, x: ^f64, y: ^f64) ---
	DrawMatrixTransformSize :: proc(m: ^DrawMatrix, x: ^f64, y: ^f64) ---

	DrawTransform :: proc(c: ^DrawContext, m: ^DrawMatrix) ---

	DrawClip :: proc(c: ^DrawContext, path: ^DrawPath) ---

	DrawSave :: proc(c: ^DrawContext) ---
	DrawRestore :: proc(c: ^DrawContext) ---

	// @role uiAttribute destructor
	// uiFreeAttribute() frees a uiAttribute. You generally do not need to
	// call this yourself, as uiAttributedString does this for you. In fact,
	// it is an error to call this function on a uiAttribute that has been
	// given to a uiAttributedString. You can call this, however, if you
	// created a uiAttribute that you aren't going to use later.
	FreeAttribute :: proc(a: ^Attribute) ---

	// uiAttributeGetType() returns the type of a.
	AttributeGetType :: proc(#by_ptr a: Attribute) -> AttributeType ---

	// uiNewFamilyAttribute() creates a new uiAttribute that changes the
	// font family of the text it is applied to. family is copied you do not
	// need to keep it alive after uiNewFamilyAttribute() returns. Font
	// family names are case-insensitive.
	NewFamilyAttribute :: proc(family: cstring) -> ^Attribute ---

	// uiAttributeFamily() returns the font family stored in a. The
	// returned string is owned by a. It is an error to call this on a
	// uiAttribute that does not hold a font family.
	AttributeFamily :: proc(#by_ptr a: Attribute) -> cstring ---

	// uiNewSizeAttribute() creates a new uiAttribute that changes the
	// size of the text it is applied to, in typographical points.
	NewSizeAttribute :: proc(size: f64) -> ^Attribute ---

	// uiAttributeSize() returns the font size stored in a. It is an error to
	// call this on a uiAttribute that does not hold a font size.
	AttributeSize :: proc(#by_ptr a: Attribute) -> f64 ---

	// uiNewWeightAttribute() creates a new uiAttribute that changes the
	// weight of the text it is applied to. It is an error to specify a weight
	// outside the range [uiTextWeightMinimum,
	// uiTextWeightMaximum].
	NewWeightAttribute :: proc(weight: TextWeight) -> ^Attribute ---

	// uiAttributeWeight() returns the font weight stored in a. It is an error
	// to call this on a uiAttribute that does not hold a font weight.
	AttributeWeight :: proc(#by_ptr a: Attribute) -> TextWeight ---

	// uiNewItalicAttribute() creates a new uiAttribute that changes the
	// italic mode of the text it is applied to. It is an error to specify an
	// italic mode not specified in uiTextItalic.
	NewItalicAttribute :: proc(italic: TextItalic) -> ^Attribute ---

	// uiAttributeItalic() returns the font italic mode stored in a. It is an
	// error to call this on a uiAttribute that does not hold a font italic
	// mode.
	AttributeItalic :: proc(#by_ptr a: Attribute) -> TextItalic ---

	// uiNewStretchAttribute() creates a new uiAttribute that changes the
	// stretch of the text it is applied to. It is an error to specify a strech
	// not specified in uiTextStretch.
	NewStretchAttribute :: proc(stretch: TextStretch) -> ^Attribute ---

	// uiAttributeStretch() returns the font stretch stored in a. It is an
	// error to call this on a uiAttribute that does not hold a font stretch.
	AttributeStretch :: proc(#by_ptr a: Attribute) -> TextStretch ---

	// uiNewColorAttribute() creates a new uiAttribute that changes the
	// color of the text it is applied to. It is an error to specify an invalid
	// color.
	NewColorAttribute :: proc(r, g, b, a: f64) -> ^Attribute ---

	// uiAttributeColor() returns the text color stored in a. It is an
	// error to call this on a uiAttribute that does not hold a text color.
	AttributeColor :: proc(#by_ptr a: Attribute, r, g, b, alpha: ^f64) ---

	// uiNewBackgroundAttribute() creates a new uiAttribute that
	// changes the background color of the text it is applied to. It is an
	// error to specify an invalid color.
	NewBackgroundAttribute :: proc(r, g, b, a: f64) -> ^Attribute ---

	// uiNewUnderlineAttribute() creates a new uiAttribute that changes
	// the type of underline on the text it is applied to. It is an error to
	// specify an underline type not specified in uiUnderline.
	NewUnderlineAttribute :: proc(u: Underline) -> ^Attribute ---

	// uiAttributeUnderline() returns the underline type stored in a. It is
	// an error to call this on a uiAttribute that does not hold an underline
	// style.
	AttributeUnderline :: proc(#by_ptr a: Attribute) -> Underline ---

	// uiNewUnderlineColorAttribute() creates a new uiAttribute that
	// changes the color of the underline on the text it is applied to.
	// It is an error to specify an underline color not specified in
	// uiUnderlineColor.
	//
	// If the specified color type is uiUnderlineColorCustom, it is an
	// error to specify an invalid color value. Otherwise, the color values
	// are ignored and should be specified as zero.
	NewUnderlineColorAttribute :: proc(u: UnderlineColor, r, g, b, a: f64) -> ^Attribute ---

	// uiAttributeUnderlineColor() returns the underline color stored in
	// a. It is an error to call this on a uiAttribute that does not hold an
	// underline color.
	AttributeUnderlineColor :: proc(#by_ptr a: Attribute, u: ^UnderlineColor, r, g, b, alpha: ^f64) ---

	// @role uiOpenTypeFeatures constructor
	// uiNewOpenTypeFeatures() returns a new uiOpenTypeFeatures
	// instance, with no tags yet added.
	NewOpenTypeFeatures :: proc() -> ^OpenTypeFeatures ---

	// @role uiOpenTypeFeatures destructor
	// uiFreeOpenTypeFeatures() frees otf.
	FreeOpenTypeFeatures :: proc(otf: ^OpenTypeFeatures) ---

	// uiOpenTypeFeaturesClone() makes a copy of otf and returns it.
	// Changing one will not affect the other.
	OpenTypeFeaturesClone :: proc(#by_ptr otf: OpenTypeFeatures) -> ^OpenTypeFeatures ---

	// uiOpenTypeFeaturesAdd() adds the given feature tag and value
	// to otf. The feature tag is specified by a, b, c, and d. If there is
	// already a value associated with the specified tag in otf, the old
	// value is removed.
	OpenTypeFeaturesAdd :: proc(otf: ^OpenTypeFeatures, a, b, c_, d: c.char, value: c.uint32_t) ---

	// uiOpenTypeFeaturesRemove() removes the given feature tag
	// and value from otf. If the tag is not present in otf,
	// uiOpenTypeFeaturesRemove() does nothing.
	OpenTypeFeaturesRemove :: proc(otf: ^OpenTypeFeatures, a, b, c_, d: c.char) ---

	// uiOpenTypeFeaturesGet() determines whether the given feature
	// tag is present in otf. If it is, *value is set to the tag's value and
	// nonzero is returned. Otherwise, zero is returned.
	//
	// Note that if uiOpenTypeFeaturesGet() returns zero, value isn't
	// changed. This is important: if a feature is not present in a
	// uiOpenTypeFeatures, the feature is NOT treated as if its
	// value was zero anyway. Script-specific font shaping rules and
	// font-specific feature settings may use a different default value
	// for a feature. You should likewise not treat a missing feature as
	// having a value of zero either. Instead, a missing feature should
	// be treated as having some unspecified default value.
	OpenTypeFeaturesGet :: proc(#by_ptr otf: OpenTypeFeatures, a, b, c_, d: c.char, value: ^c.uint32_t) -> c.int ---

	// uiOpenTypeFeaturesForEach() executes f for every tag-value
	// pair in otf. The enumeration order is unspecified. You cannot
	// modify otf while uiOpenTypeFeaturesForEach() is running.
	OpenTypeFeaturesForEach :: proc(#by_ptr otf: OpenTypeFeatures, f: OpenTypeFeaturesForEachFunc, data: rawptr) ---

	// uiNewFeaturesAttribute() creates a new uiAttribute that changes
	// the font family of the text it is applied to. otf is copied you may
	// free it after uiNewFeaturesAttribute() returns.
	// TODO: should be #by_ptr but that causes a crash for some reason
	NewFeaturesAttribute :: proc(otf: ^OpenTypeFeatures) -> ^Attribute ---

	// uiAttributeFeatures() returns the OpenType features stored in a.
	// The returned uiOpenTypeFeatures object is owned by a. It is an
	// error to call this on a uiAttribute that does not hold OpenType
	// features.
	AttributeFeatures :: proc(#by_ptr a: Attribute) -> ^OpenTypeFeatures ---

	// @role uiAttributedString constructor
	// uiNewAttributedString() creates a new uiAttributedString from
	// initialString. The string will be entirely unattributed.
	NewAttributedString :: proc(initialString: cstring) -> ^AttributedString ---

	// @role uiAttributedString destructor
	// uiFreeAttributedString() destroys the uiAttributedString s.
	// It will also free all uiAttributes within.
	FreeAttributedString :: proc(s: ^AttributedString) ---

	// uiAttributedStringString() returns the textual content of s as a
	// '\0'-terminated UTF-8 string. The returned pointer is valid until
	// the next change to the textual content of s.
	AttributedStringString :: proc(#by_ptr s: AttributedString) -> cstring ---

	// uiAttributedStringLength() returns the number of UTF-8 bytes in
	// the textual content of s, excluding the terminating '\0'.
	AttributedStringLen :: proc(#by_ptr s: AttributedString) -> c.size_t ---

	// uiAttributedStringAppendUnattributed() adds the '\0'-terminated
	// UTF-8 string str to the end of s. The new substring will be
	// unattributed.
	AttributedStringAppendUnattributed :: proc(s: ^AttributedString, str: cstring) ---

	// uiAttributedStringInsertAtUnattributed() adds the '\0'-terminated
	// UTF-8 string str to s at the byte position specified by at. The new
	// substring will be unattributed existing attributes will be moved
	// along with their text.
	AttributedStringInsertAtUnattributed :: proc(s: ^AttributedString, str: cstring, at: c.size_t) ---

	// uiAttributedStringDelete() deletes the characters and attributes of
	// s in the byte range [start, end).
	AttributedStringDelete :: proc(s: ^AttributedString, start: c.size_t, end: c.size_t) ---

	// uiAttributedStringSetAttribute() sets a in the byte range [start, end)
	// of s. Any existing attributes in that byte range of the same type are
	// removed. s takes ownership of a you should not use it after
	// uiAttributedStringSetAttribute() returns.
	AttributedStringSetAttribute :: proc(s: ^AttributedString, a: ^Attribute, start: c.size_t, end: c.size_t) ---

	// uiAttributedStringForEachAttribute() enumerates all the
	// uiAttributes in s. It is an error to modify s in f. Within f, s still
	// owns the attribute you can neither free it nor save it for later
	// use.
	AttributedStringForEachAttribute :: proc(#by_ptr s: AttributedString, f: AttributedStringForEachAttributeFunc, data: rawptr) ---

	AttributedStringNumGraphemes :: proc(s: ^AttributedString) -> c.size_t ---
	AttributedStringByteIndexToGrapheme :: proc(s: ^AttributedString, pos: c.size_t) -> c.size_t ---
	AttributedStringGraphemeToByteIndex :: proc(s: ^AttributedString, pos: c.size_t) -> c.size_t ---

	LoadControlFont :: proc(f: ^FontDescriptor) ---
	FreeFontDescriptor :: proc(desc: ^FontDescriptor) ---

	// @role uiDrawTextLayout constructor
	// uiDrawNewTextLayout() creates a new uiDrawTextLayout from
	// the given parameters.
	DrawNewTextLayout :: proc(params: ^DrawTextLayoutParams) -> ^DrawTextLayout ---

	// @role uiDrawFreeTextLayout destructor
	// uiDrawFreeTextLayout() frees tl. The underlying
	// uiAttributedString is not freed.
	DrawFreeTextLayout :: proc(tl: ^DrawTextLayout) ---

	// uiDrawText() draws tl in c with the top-left point of tl at (x, y).
	DrawText :: proc(c: ^DrawContext, tl: ^DrawTextLayout, x, y: f64) ---

	// uiDrawTextLayoutExtents() returns the width and height of tl
	// in width and height. The returned width may be smaller than
	// the width passed into uiDrawNewTextLayout() depending on
	// how the text in tl is wrapped. Therefore, you can use this
	// function to get the actual size of the text layout.
	DrawTextLayoutExtents :: proc(tl: ^DrawTextLayout, width, height: ^f64) ---

	/**
	* Returns the selected font.
	*
	* @param b uiFontButton instance.
	* @param[out] desc Font descriptor. [Default: OS-dependent].
	* @note Make sure to call `uiFreeFontButtonFont()` to free all allocated
	*       resources within @p desc.
	* @memberof uiFontButton
	*/
	FontButtonFont :: proc(b: ^FontButton, desc: ^FontDescriptor) ---

	/**
	*  Registers a callback for when the font is changed.
	*
	* @param b uiFontButton instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiFontButton
	*/
	FontButtonOnChanged :: proc(b: ^FontButton, f: #type proc(sender: ^FontButton, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new font button.
	*
	* The default font is determined by the OS defaults.
	*
	* @returns A new uiFontButton instance.
	* @memberof uiFontButton @static
	*/
	NewFontButton :: proc() -> ^FontButton ---

	/**
	* Frees a uiFontDescriptor previously filled by uiFontButtonFont().
	*
	* After calling this function the contents of @p desc should be assumed undefined,
	* however you can safely reuse @p desc.
	*
	* Calling this function on a uiFontDescriptor not previously filled by
	* uiFontButtonFont() results in undefined behavior.
	*
	* @param desc Font descriptor to free.
	* @memberof uiFontButton
	*/
	FreeFontButtonFont :: proc(desc: ^FontDescriptor) ---

	/**
	* Returns the color button color.
	*
	* @param b uiColorButton instance.
	* @param[out] r Red. Double in range of [0, 1.0].
	* @param[out] g Green. Double in range of [0, 1.0].
	* @param[out] bl Blue. Double in range of [0, 1.0].
	* @param[out] a Alpha. Double in range of [0, 1.0].
	* @memberof uiColorButton
	*/
	ColorButtonColor :: proc(b: ^ColorButton, r, g, bl, a: ^f64) ---

	/**
	* Sets the color button color.
	*
	* @param b uiColorButton instance.
	* @param r Red. Double in range of [0, 1.0].
	* @param g Green. Double in range of [0, 1.0].
	* @param bl Blue. Double in range of [0, 1.0].
	* @param a Alpha. Double in range of [0, 1.0].
	* @memberof uiColorButton
	*/
	ColorButtonSetColor :: proc(b: ^ColorButton, r, g, bl, a: f64) ---

	/** Registers a callback for when the color is changed.
	*
	* @param b uiColorButton instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiColorButtonSetColor().
	* @note Only one callback can be registered at a time.
	* @memberof uiColorButton
	*/
	ColorButtonOnChanged :: proc(b: ^ColorButton, f: #type proc(sender: ^ColorButton, senderData: rawptr), data: rawptr) ---

	/**
	* Creates a new color button.
	*
	* @returns A new uiColorButton instance.
	* @memberof uiColorButton @static
	*/
	NewColorButton :: proc() -> ^ColorButton ---

	/**
	* Appends a control with a label to the form.
	*
	* Stretchy items expand to use the remaining space within the container.
	* In the case of multiple stretchy items the space is shared equally.
	*
	* @param f uiForm instance.
	* @param label Label text.\n
	*              A `NUL` terminated UTF-8 string.\n
	*              Data is copied internally. Ownership is not transferred.
	* @param c Control to append.
	* @param stretchy `TRUE` to stretch control, `FALSE` otherwise.
	* @memberof uiForm
	*/
	FormAppend :: proc(f: ^Form, label: cstring, c: ^Control, stretchy: b32) ---

	/**
	* Returns the number of controls contained within the form.
	*
	* @param f uiForm instance.
	* @memberof uiForm
	*/
	FormNumChildren :: proc(f: ^Form) -> c.int ---

	/**
	* Removes the control at @p index from the form.
	*
	* @param f uiForm instance.
	* @param index Index of the control to be removed.
	* @note The control is neither destroyed nor freed.
	* @memberof uiForm
	*/
	FormDelete :: proc(f: ^Form, index: c.int) ---

	/**
	* Returns whether or not controls within the form are padded.
	*
	* Padding is defined as space between individual controls.
	*
	* @param f uiForm instance.
	* @returns `TRUE` if controls are padded, `FALSE` otherwise.
	* @memberof uiForm
	*/
	FormPadded :: proc(f: ^Form) -> b32 ---

	/**
	* Sets in whether or not controls within the box are padded.
	*
	* Padding is defined as space between individual controls.
	* The padding size is determined by the OS defaults.
	*
	* @param f uiForm instance.
	* @param padded  `TRUE` to make controls padded, `FALSE` otherwise.
	* @memberof uiForm
	*/
	FormSetPadded :: proc(f: ^Form, padded: b32) ---

	/**
	* Creates a new form.
	*
	* @returns A new uiForm instance.
	* @memberof uiForm @static
	*/
	NewForm :: proc() -> ^Form ---

	/**
	* Appends a control to the grid.
	*
	* @param g uiGrid instance.
	* @param c The control to insert.
	* @param left Placement as number of columns from the left. Integer in range of `[INT_MIN, INT_MAX]`.
	* @param top Placement as number of rows from the top. Integer in range of `[INT_MIN, INT_MAX]`.
	* @param xspan Number of columns to span. Integer in range of `[0, INT_MAX]`.
	* @param yspan Number of rows to span. Integer in range of `[0, INT_MAX]`.
	* @param hexpand `TRUE` to expand reserved area horizontally, `FALSE` otherwise.
	* @param halign Horizontal alignment of the control within the reserved space.
	* @param vexpand `TRUE` to expand reserved area vertically, `FALSE` otherwise.
	* @param valign Vertical alignment of the control within the reserved space.
	* @memberof uiGrid
	*/
	GridAppend :: proc(g: ^Grid, c_: ^Control, left: c.int, top: c.int, xspan: c.int, yspan: c.int, hexpand: b32, halign: Align, vexpand: b32, valign: Align) ---

	/**
	* Inserts a control positioned in relation to another control within the grid.
	*
	* @param g uiGrid instance.
	* @param c The control to insert.
	* @param existing The existing control to position relatively to.
	* @param at Placement specifier in relation to @p existing control.
	* @param xspan Number of columns to span. Integer in range of `[0, INT_MAX]`.
	* @param yspan Number of rows to span. Integer in range of `[0, INT_MAX]`.
	* @param hexpand `TRUE` to expand reserved area horizontally, `FALSE` otherwise.
	* @param halign Horizontal alignment of the control within the reserved space.
	* @param vexpand `TRUE` to expand reserved area vertically, `FALSE` otherwise.
	* @param valign Vertical alignment of the control within the reserved space.
	* @memberof uiGrid
	*/
	GridInsertAt :: proc(g: ^Grid, c_: ^Control, existing: ^Control, at: At, xspan: c.int, yspan: c.int, hexpand: b32, halign: Align, vexpand: b32, valign: Align) ---

	/**
	* Returns whether or not controls within the grid are padded.
	*
	* Padding is defined as space between individual controls.
	*
	* @param g uiGrid instance.
	* @returns `TRUE` if controls are padded, `FALSE` otherwise.
	* @memberof uiGrid
	*/
	GridPadded :: proc(g: ^Grid) -> b32 ---

	/**
	* Sets whether or not controls within the grid are padded.
	*
	* Padding is defined as space between individual controls.
	* The padding size is determined by the OS defaults.
	*
	* @param g uiGrid instance.
	* @param padded  `TRUE` to make controls padded, `FALSE` otherwise.
	* @memberof uiGrid
	*/
	GridSetPadded :: proc(g: ^Grid, padded: b32) ---

	/**
	* Creates a new grid.
	*
	* @returns A new uiGrid instance.
	* @memberof uiGrid @static
	*/
	NewGrid :: proc() -> ^Grid ---

	/**
	* Creates a new image container.
	*
	* Dimensions are measured in points. This is most commonly the pixel size
	* of the `1x` scaled image.
	*
	* @param width Width in points.
	* @param height Height in points.
	* @returns A new uiImage instance.
	* @memberof uiImage @static
	*/
	NewImage :: proc(width, height: f64) -> ^Image ---

	/**
	* Frees the image container and all associated resources.
	*
	* @param i uiImage instance.
	* @memberof uiImage
	*/
	FreeImage :: proc(i: ^Image) ---

	/**
	* Appends a new image representation.
	*
	* @param i uiImage instance.
	* @param pixels Byte array of premultiplied pixels in [R G B A] order.\n
	*               `((uint8_t *) pixels)[0]` equals the **R** of the first pixel,
	*               `[3]` the **A** of the first pixel.\n
	*               `pixels` must be at least `byteStride * pixelHeight` bytes long.\n
	*               Data is copied internally. Ownership is not transferred.
	* @param pixelWidth Width in pixels.
	* @param pixelHeight Height in pixels.
	* @param byteStride Number of bytes per row of the pixel array.
	* @todo see if we either need the stride or can provide a way to get the OS-preferred stride (in cairo we do)
	* @todo use const void * for const correctness
	* @memberof uiImage
	*/
	ImageAppend :: proc(i: ^Image, pixels: rawptr, pixelWidth: c.int, pixelHeight: c.int, byteStride: c.int) ---

	/**
	* Frees the uiTableValue.
	*
	* @param v Table value to free.
	*
	* @warning This function is to be used only on uiTableValue objects that
	*          have NOT been passed to uiTable or uiTableModel - as these
	*          take ownership of the object.\n
	*          Use this for freeing erroneously created values or when directly
	*          calling uiTableModelHandler without transferring ownership to
	*          uiTable or uiTableModel.
	* @memberof uiTableValue
	*/
	FreeTableValue :: proc(v: ^TableValue) ---

	/**
	* Gets the uiTableValue type.
	*
	* @param v Table value.
	* @returns Table value type.
	* @memberof uiTableValue
	*/
	TableValueGetType :: proc(#by_ptr v: TableValue) -> TableValueType ---

	/**
	* Creates a new table value to store a text string.
	*
	* @param str String value.\n
	*            A valid, `NUL` terminated UTF-8 string.\n
	*            Data is copied internally. Ownership is not transferred.
	* @returns A new uiTableValue instance.
	* @memberof uiTableValue @static
	*/
	NewTableValueString :: proc(str: cstring) -> ^TableValue ---

	/**
	* Returns the string value held internally.
	*
	* To be used only on uiTableValue objects of type uiTableValueTypeString.
	*
	* @param v Table value.
	* @returns String value.\n
	*          A `NUL` terminated UTF-8 string.\n
	*          Data remains owned by @p v, do **NOT** call `uiFreeText()`.
	* @memberof uiTableValue
	*/
	TableValueString :: proc(#by_ptr v: TableValue) -> cstring ---

	/**
	* Creates a new table value to store an image.
	*
	* @param img Image.\n
	*            Data is NOT copied and needs to kept alive.
	* @returns A new uiTableValue instance.
	* @warning Unlike other uiTableValue constructors, uiNewTableValueImage() does
	*          NOT copy the image to save time and space. Make sure the image
	*          data stays valid while in use by the library.
	*          As a general rule: if the constructor is called via the
	*          uiTableModelHandler, the image is safe to free once execution
	*          returns to ANY of your code.
	* @memberof uiTableValue @static
	*/
	NewTableValueImage :: proc(img: ^Image) -> ^TableValue ---

	/**
	* Returns a reference to the image contained.
	*
	* To be used only on uiTableValue objects of type uiTableValueTypeImage.
	*
	* @param v Table value.
	* @returns Image.\n
	*          Data is owned by the caller of uiNewTableValueImage().
	* @warning The image returned is not owned by the object @p v,
	*          hence no lifetime guarantees can be made.
	* @memberof uiTableValue
	*/
	TableValueImage :: proc(#by_ptr v: TableValue) -> ^Image ---

	/**
	* Creates a new table value to store an integer.
	*
	* This value type can be used in conjunction with properties like
	* column editable [`TRUE`, `FALSE`] or controls like progress bars and
	* checkboxes. For these, consult uiProgressBar and uiCheckbox for the allowed
	* integer ranges.
	*
	* @param i Integer value.
	* @returns A new uiTableValue instance.
	* @memberof uiTableValue @static
	*/
	NewTableValueInt :: proc(i: c.int) -> ^TableValue ---

	/**
	* Returns the integer value held internally.
	*
	* To be used only on uiTableValue objects of type uiTableValueTypeInt.
	*
	* @param v Table value.
	* @returns Integer value.
	* @memberof uiTableValue
	*/
	TableValueInt :: proc(#by_ptr v: TableValue) -> c.int ---

	/**
	* Creates a new table value to store a color in.
	*
	* @param r Red. Double in range of [0, 1.0].
	* @param g Green. Double in range of [0, 1.0].
	* @param b Blue. Double in range of [0, 1.0].
	* @param a Alpha. Double in range of [0, 1.0].
	* @returns A new uiTableValue instance.
	* @memberof uiTableValue @static
	*/
	NewTableValueColor :: proc(r, g, b, a: f64) -> ^TableValue ---

	/**
	* Returns the color value held internally.
	*
	* To be used only on uiTableValue objects of type uiTableValueTypeColor.
	*
	* @param v Table value.
	* @param[out] r Red. Double in range of [0, 1.0].
	* @param[out] g Green. Double in range of [0, 1.0].
	* @param[out] b Blue. Double in range of [0, 1.0].
	* @param[out] a Alpha. Double in range of [0, 1.0].
	* @memberof uiTableValue
	*/
	TableValueColor :: proc(#by_ptr v: TableValue, r, g, b, a: ^f64) ---

	/**
	* Creates a new table model.
	*
	* @param mh Table model handler.
	* @returns A new uiTableModel instance.
	* @memberof uiTableModel @static
	*/
	NewTableModel :: proc(mh: ^TableModelHandler) -> ^TableModel ---

	/**
	* Frees the table model.
	*
	* @param m Table model to free.
	* @warning It is an error to free table models currently associated with a
	*          uiTable.
	* @memberof uiTableModel
	*/
	FreeTableModel :: proc(m: ^TableModel) ---

	/**
	* Informs all associated uiTable views that a new row has been added.
	*
	* You must insert the row data in your model before calling this function.
	*
	* NumRows() must represent the new row count before you call this function.
	*
	* @param m Table model that has changed.
	* @param newIndex Index of the row that has been added.
	* @memberof uiTableModel
	*/
	TableModelRowInserted :: proc(m: ^TableModel, newIndex: c.int) ---

	/**
	* Informs all associated uiTable views that a row has been changed.
	*
	* You do NOT need to call this in your SetCellValue() handlers, but NEED
	* to call this if your data changes at any other point.
	*
	* @param m Table model that has changed.
	* @param index Index of the row that has changed.
	* @memberof uiTableModel
	*/
	TableModelRowChanged :: proc(m: ^TableModel, index: c.int) ---

	/**
	* Informs all associated uiTable views that a row has been deleted.
	*
	* You must delete the row from your model before you call this function.
	*
	* NumRows() must represent the new row count before you call this function.
	*
	* @param m Table model that has changed.
	* @param oldIndex Index of the row that has been deleted.
	* @memberof uiTableModel
	*/
	TableModelRowDeleted :: proc(m: ^TableModel, oldIndex: c.int) ---

	/**
	* Appends a text column to the table.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param textModelColumn Column that holds the text to be displayed.\n
	*                        #uiTableValueTypeString
	* @param textEditableModelColumn Column that defines whether or not the text is editable.\n
	*                                #uiTableValueTypeInt `TRUE` to make text editable, `FALSE`
	*                                otherwise.\n
	*                                `uiTableModelColumnNeverEditable` to make all rows never editable.\n
	*                                `uiTableModelColumnAlwaysEditable` to make all rows always editable.
	* @param textParams Text display settings, `NULL` to use defaults.
	* @memberof uiTable
	*/
	TableAppendTextColumn :: proc(t: ^Table, name: cstring, textModelColumn: c.int, textEditableModelColumn: c.int, textParams: ^TableTextColumnOptionalParams) ---

	/**
	* Appends an image column to the table.
	*
	* Images are drawn at icon size, using the representation that best fits the
	* pixel density of the screen.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param imageModelColumn Column that holds the images to be displayed.\n
	*                         #uiTableValueTypeImage
	* @memberof uiTable
	*/
	TableAppendImageColumn :: proc(t: ^Table, name: cstring, imageModelColumn: c.int) ---

	/**
	* Appends a column to the table that displays both an image and text.
	*
	* Images are drawn at icon size, using the representation that best fits the
	* pixel density of the screen.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param imageModelColumn Column that holds the images to be displayed.\n
	*                         #uiTableValueTypeImage
	* @param textModelColumn Column that holds the text to be displayed.\n
	*                        #uiTableValueTypeString
	* @param textEditableModelColumn Column that defines whether or not the text is editable.\n
	*                                #uiTableValueTypeInt `TRUE` to make text editable, `FALSE` otherwise.\n
	*                                `uiTableModelColumnNeverEditable` to make all rows never editable.\n
	*                                `uiTableModelColumnAlwaysEditable` to make all rows always editable.
	* @param textParams Text display settings, `NULL` to use defaults.
	* @memberof uiTable
	*/
	TableAppendImageTextColumn :: proc(t: ^Table, name: cstring, imageModelColumn: c.int, textModelColumn: c.int, textEditableModelColumn: c.int, textParams: ^TableTextColumnOptionalParams) ---

	/**
	* Appends a column to the table containing a checkbox.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param checkboxModelColumn Column that holds the data to be displayed.\n
	*                            #uiTableValueTypeInt `TRUE` for a checked checkbox, `FALSE` otherwise.
	* @param checkboxEditableModelColumn Column that defines whether or not the checkbox is editable.\n
	*                                    #uiTableValueTypeInt `TRUE` to make checkbox editable, `FALSE` otherwise.\n
	*                                    `uiTableModelColumnNeverEditable` to make all rows never editable.\n
	*                                    `uiTableModelColumnAlwaysEditable` to make all rows always editable.
	* @memberof uiTable
	*/
	TableAppendCheckboxColumn :: proc(t: ^Table, name: cstring, checkboxModelColumn: c.int, checkboxEditableModelColumn: c.int) ---

	/**
	* Appends a column to the table containing a checkbox and text.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param checkboxModelColumn Column that holds the data to be displayed.\n
	*                            #uiTableValueTypeInt
	*                            `TRUE` for a checked checkbox, `FALSE` otherwise.
	* @param checkboxEditableModelColumn Column that defines whether or not the checkbox is editable.\n
	*                                    #uiTableValueTypeInt `TRUE` to make checkbox editable, `FALSE` otherwise.\n
	*                                    `uiTableModelColumnNeverEditable` to make all rows never editable.\n
	*                                    `uiTableModelColumnAlwaysEditable` to make all rows always editable.
	* @param textModelColumn Column that holds the text to be displayed.\n
	*                        #uiTableValueTypeString
	* @param textEditableModelColumn Column that defines whether or not the text is editable.\n
	*                                #uiTableValueTypeInt `TRUE` to make text editable, `FALSE` otherwise.\n
	*                                `uiTableModelColumnNeverEditable` to make all rows never editable.\n
	*                                `uiTableModelColumnAlwaysEditable` to make all rows always editable.
	* @param textParams Text display settings, `NULL` to use defaults.
	* @memberof uiTable
	*/
	TableAppendCheckboxTextColumn :: proc(t: ^Table, name: cstring, checkboxModelColumn: c.int, checkboxEditableModelColumn: c.int, textModelColumn: c.int, textEditableModelColumn: c.int, textParams: ^TableTextColumnOptionalParams) ---

	/**
	* Appends a column to the table containing a progress bar.
	*
	* The workings and valid range are exactly the same as that of uiProgressBar.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param progressModelColumn Column that holds the data to be displayed.\n
	*                            #uiTableValueTypeInt Integer in range of `[-1, 100]`, see uiProgressBar
	*                            for details.
	* @see uiProgressBar
	* @memberof uiTable
	*/
	TableAppendProgressBarColumn :: proc(t: ^Table, name: cstring, progressModelColumn: c.int) ---

	/**
	* Appends a column to the table containing a button.
	*
	* Button clicks are signaled to the uiTableModelHandler via a call to
	* SetCellValue() with a value of `NULL` for the @p buttonModelColumn.
	*
	* CellValue() must return the button text to display.
	*
	* @param t uiTable instance.
	* @param name Column title text.\n
	*             A valid, `NUL` terminated UTF-8 string.\n
	*             Data is copied internally. Ownership is not transferred.
	* @param buttonModelColumn Column that holds the button text to be displayed.\n
	*                          #uiTableValueTypeString
	* @param buttonClickableModelColumn Column that defines whether or not the button is clickable.\n
	*                                   #uiTableValueTypeInt `TRUE` to make button clickable, `FALSE` otherwise.\n
	*                                   `uiTableModelColumnNeverEditable` to make all rows never clickable.\n
	*                                   `uiTableModelColumnAlwaysEditable` to make all rows always clickable.
	* @memberof uiTable
	*/
	TableAppendButtonColumn :: proc(t: ^Table, name: cstring, buttonModelColumn: c.int, buttonClickableModelColumn: c.int) ---

	/**
	* Returns whether or not the table header is visible.
	*
	* @param t uiTable instance.
	* @returns `TRUE` if visible, `FALSE` otherwise. [Default `TRUE`]
	* @memberof uiTable
	*/
	TableHeaderVisible :: proc(t: ^Table) -> b32 ---

	/**
	* Sets whether or not the table header is visible.
	*
	* @param t uiTable instance.
	* @param visible `TRUE` to show header, `FALSE` to hide header.
	* @memberof uiTable
	*/
	TableHeaderSetVisible :: proc(t: ^Table, visible: b32) ---

	/**
	* Creates a new table.
	*
	* @param params Table parameters.
	* @returns A new uiTable instance.
	* @memberof uiTable @static
	*/
	NewTable :: proc(params: ^TableParams) -> ^Table ---


	/**
	* Registers a callback for when the user single clicks a table row.
	*
	* @param t uiTable instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p row Row index that was clicked.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiTable
	*/
	TableOnRowClicked :: proc(t: ^Table, f: #type proc(t: ^Table, row: c.int, data: rawptr), data: rawptr) ---

	/**
	* Registers a callback for when the user double clicks a table row.
	*
	* @param t uiTable instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p row Row index that was double clicked.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The double click callback is always preceded by one uiTableOnRowClicked() callback.
	* @bug For unix systems linking against `GTK < 3.14` the preceding uiTableOnRowClicked()
	*      callback will be triggered twice.
	* @note Only one callback can be registered at a time.
	* @memberof uiTable
	*/
	TableOnRowDoubleClicked :: proc(t: ^Table, f: #type proc(t: ^Table, row: c.int, data: rawptr), data: rawptr) ---

	/**
	* Sets the column's sort indicator displayed in the table header.
	*
	* Use this to display appropriate arrows in the table header to indicate a
	* sort direction.
	*
	* @param t uiTable instance.
	* @param column Column index.
	* @param indicator Sort indicator.
	* @note Setting the indicator is purely visual and does not perform any sorting.
	* @memberof uiTable
	*/
	TableHeaderSetSortIndicator :: proc(t: ^Table, column: c.int, indicator: SortIndicator) ---

	/**
	* Returns the column's sort indicator displayed in the table header.
	*
	* @param t uiTable instance.
	* @param column Column index.
	* @returns The current sort indicator. [Default: `uiSortIndicatorNone`]
	* @memberof uiTable
	*/
	TableHeaderSortIndicator :: proc(t: ^Table, column: c.int) -> SortIndicator ---

	/**
	* Registers a callback for when a table column header is clicked.
	*
	* @param t uiTable instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p column Column index that was clicked.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note Only one callback can be registered at a time.
	* @memberof uiTable
	*/
	TableHeaderOnClicked :: proc(t: ^Table, f: #type proc(sender: ^Table, column: c.int, senderData: rawptr), data: rawptr) ---

	/**
	* Returns the table column width.
	*
	* @param t uiTable instance.
	* @param column Column index.
	* @returns Column width in pixels.
	* @memberof uiTable
	*/
	TableColumnWidth :: proc(t: ^Table, column: c.int) -> c.int ---

	/**
	* Sets the table column width.
	*
	* Setting the width to `-1` will restore automatic column sizing matching
	* either the width of the content or column header (which ever one is bigger).
	* @note Darwin currently only resizes to the column header width on `-1`.
	*
	* @param t uiTable instance.
	* @param column Column index.
	* @param width Column width to set in pixels, `-1` to restore automatic
	*              column sizing.
	* @memberof uiTable
	*/
	TableColumnSetWidth :: proc(t: ^Table, column: c.int, width: c.int) ---

	/**
	* Returns the table selection mode.
	*
	* @param t uiTable instance.
	* @returns The table selection mode. [Default `uiTableSelectionModeZeroOrOne`]
	*
	* @memberof uiTable
	*/
	TableGetSelectionMode :: proc(t: ^Table) -> TableSelectionMode ---

	/**
	* Sets the table selection mode.
	*
	* @param t uiTable instance.
	* @param mode Table selection mode to set.
	*
	* @warning All rows will be deselected if the existing selection is illegal
	*          in the new selection mode.
	* @memberof uiTable
	*/
	TableSetSelectionMode :: proc(t: ^Table, mode: TableSelectionMode) ---

	/**
	* Registers a callback for when the table selection changed.
	*
	* @param t uiTable instance.
	* @param f Callback function.\n
	*          @p sender Back reference to the instance that triggered the callback.\n
	*          @p senderData User data registered with the sender instance.
	* @param data User data to be passed to the callback.
	*
	* @note The callback is not triggered when calling uiTableSetSelection() or
	*       when needing to clear the selection on uiTableSetSelectionMode().
	* @note Only one callback can be registered at a time.
	* @memberof uiTable
	*/
	TableOnSelectionChanged :: proc(t: ^Table, f: #type proc(t: ^Table, data: rawptr), data: rawptr) ---

	/**
	* Returns the current table selection.
	*
	* @param t uiTable instance.
	* @returns The number of selected rows and corresponding row indices.\n
	*          Caller is responsible for freeing the data with `uiFreeTableSelection()`.
	*
	* @note For empty selections the `Rows` pointer will be NULL.
	* @memberof uiTable
	*/
	TableGetSelection :: proc(t: ^Table) -> ^TableSelection ---

	/**
	* Sets the current table selection clearing any previous selection.
	*
	* @param t uiTable instance.
	* @param sel Table selection.\n
	*            Data is copied internally. Ownership is not transferred.
	*
	* @note Selecting more rows than the selection mode allows for results in nothing happening.
	* @note For empty selections the Rows pointer is never accessed.
	* @memberof uiTable
	*/
	TableSetSelection :: proc(t: ^Table, sel: ^TableSelection) ---

	/**
	* Frees the given uiTableSelection and all it's resources.
	*
	* @param s uiTableSelection instance.
	* @memberof uiTableSelection
	*/
	FreeTableSelection :: proc(s: ^TableSelection) ---
}
