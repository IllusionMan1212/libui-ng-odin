package libui_histogram

import "core:c"
import "core:math/rand"
import "core:fmt"

import "../../"

mainwin: ^libui.Window
histogram: ^libui.Area
handler: libui.AreaHandler
datapoints: [10]^libui.Spinbox
colorButton: ^libui.ColorButton
currentPoint: c.int = -1

// some metrics
xoffLeft    :: 20			/* histogram margins */
yoffTop     :: 20
xoffRight   :: 20
yoffBottom  :: 20
pointRadius :: 5

// and some colors
// names and values from https://msdn.microsoft.com/en-us/library/windows/desktop/dd370907%28v=vs.85%29.aspx
colorWhite 			:: 0xFFFFFF
colorBlack 			:: 0x000000
colorDodgerBlue :: 0x1E90FF

// helper to quickly set a brush color
setSolidBrush :: proc(brush: ^libui.DrawBrush, color: c.uint32_t, alpha: c.double) {
	component: c.uint8_t

	brush.Type = .Solid
	component = cast(c.uint8_t)((color >> 16) & 0xFF)
	brush.R = (cast(c.double)component) / 255
	component = cast(c.uint8_t)((color >> 8) & 0xFF)
	brush.G = (cast(c.double)component) / 255
	component = cast(c.uint8_t)(color & 0xFF)
	brush.B = (cast(c.double)component) / 255
	brush.A = alpha
}

pointLocations :: proc(width: c.double, height: c.double, xs: [^]c.double, ys: [^]c.double) {
	xincr: c.double
	yincr: c.double
	n: c.int

	xincr = width / 9		// 10 - 1 to make the last point be at the end
	yincr = height / 100

	for i in 0..<10 {
		// get the value of the point
		n = libui.SpinboxValue(datapoints[i])
		// because y=0 is the top but n=0 is the bottom, we need to flip
		n = 100 - n
		xs[i] = xincr * f64(i)
		ys[i] = yincr * f64(n)
	}
}

constructGraph :: proc(width: c.double, height: c.double, extend: bool) -> ^libui.DrawPath {
	xs: [10]c.double
	ys: [10]c.double

	pointLocations(width, height, raw_data(&xs), raw_data(&ys))

	path := libui.DrawNewPath(.Winding)

	libui.DrawPathNewFigure(path, xs[0], ys[0])
	for i in 1..<10 {
		libui.DrawPathLineTo(path, xs[i], ys[i])
	}

	if (extend) {
		libui.DrawPathLineTo(path, width, height)
		libui.DrawPathLineTo(path, 0, height)
		libui.DrawPathCloseFigure(path)
	}

	libui.DrawPathEnd(path)
	return path
}

graphSize :: proc(clientWidth: c.double, clientHeight: c.double, graphWidth: ^c.double, graphHeight: ^c.double) {
	graphWidth^ = clientWidth - xoffLeft - xoffRight
	graphHeight^ = clientHeight - yoffTop - yoffBottom
}

handlerDraw :: proc(a: ^libui.AreaHandler, area: ^libui.Area, p: ^libui.AreaDrawParams) {
	brush: libui.DrawBrush
	// initialize sp to 0 to avoid passing garbage to uiDrawStroke()
	// for example, we don't use dashing
	sp: libui.DrawStrokeParams
	m: libui.DrawMatrix
	graphWidth: c.double
	graphHeight: c.double
	graphR: c.double
	graphG: c.double
	graphB: c.double
	graphA: c.double

	// fill the area with white
	setSolidBrush(&brush, colorWhite, 1.0)
	path := libui.DrawNewPath(.Winding)
	libui.DrawPathAddRectangle(path, 0, 0, p.AreaWidth, p.AreaHeight)
	libui.DrawPathEnd(path)
	libui.DrawFill(p.Context, path, &brush)
	libui.DrawFreePath(path)

	// figure out dimensions
	graphSize(p.AreaWidth, p.AreaHeight, &graphWidth, &graphHeight)

	// make a stroke for both the axes and the histogram line
	sp.Cap = .Flat
	sp.Join = .Miter
	sp.Thickness = 2
	sp.MiterLimit = libui.DrawDefaultMiterLimit

	// draw the axes
	setSolidBrush(&brush, colorBlack, 1.0)
	path = libui.DrawNewPath(.Winding)
	libui.DrawPathNewFigure(path,
		xoffLeft, yoffTop)
	libui.DrawPathLineTo(path,
		xoffLeft, yoffTop + graphHeight)
	libui.DrawPathLineTo(path,
		xoffLeft + graphWidth, yoffTop + graphHeight)
	libui.DrawPathEnd(path)
	libui.DrawStroke(p.Context, path, &brush, &sp)
	libui.DrawFreePath(path)

	// now transform the coordinate space so (0, 0) is the top-left corner of the graph
	libui.DrawMatrixSetIdentity(&m)
	libui.DrawMatrixTranslate(&m, xoffLeft, yoffTop)
	libui.DrawTransform(p.Context, &m)

	// now get the color for the graph itself and set up the brush
	libui.ColorButtonColor(colorButton, &graphR, &graphG, &graphB, &graphA)
	brush.Type = .Solid
	brush.R = graphR
	brush.G = graphG
	brush.B = graphB
	// we set brush.A below to different values for the fill and stroke

	// now create the fill for the graph below the graph line
	path = constructGraph(graphWidth, graphHeight, true)
	brush.A = graphA / 2
	libui.DrawFill(p.Context, path, &brush)
	libui.DrawFreePath(path)

	// now draw the histogram line
	path = constructGraph(graphWidth, graphHeight, false)
	brush.A = graphA
	libui.DrawStroke(p.Context, path, &brush, &sp)
	libui.DrawFreePath(path)

	// now draw the point being hovered over
	if currentPoint != -1 {
		xs: [10]c.double
		ys: [10]c.double

		pointLocations(graphWidth, graphHeight, raw_data(&xs), raw_data(&ys))
		path = libui.DrawNewPath(.Winding)
		libui.DrawPathNewFigureWithArc(path,
			xs[currentPoint], ys[currentPoint],
			pointRadius,
			0, 6.23,
			0)
		libui.DrawPathEnd(path)
		// use the same brush as for the histogram lines
		libui.DrawFill(p.Context, path, &brush)
		libui.DrawFreePath(path)
	}
}

inPoint :: proc(x: c.double, y: c.double, xtest: c.double, ytest: c.double) -> b32 {
	x := x
	y := y
	x -= xoffLeft
	y -= yoffTop
	return (x >= xtest - pointRadius) &&
		(x <= xtest + pointRadius) &&
		(y >= ytest - pointRadius) &&
		(y <= ytest + pointRadius)
}

handlerMouseEvent :: proc(a: ^libui.AreaHandler, area: ^libui.Area, e: ^libui.AreaMouseEvent) {
	graphWidth: c.double
	graphHeight: c.double
	i: c.int
	xs: [10]c.double
	ys: [10]c.double

	graphSize(e.AreaWidth, e.AreaHeight, &graphWidth, &graphHeight)
	pointLocations(graphWidth, graphHeight, raw_data(&xs), raw_data(&ys))

	for i in 0..<10 {
		if (inPoint(e.X, e.Y, xs[i], ys[i])) {
			break
		}
	}
	if i == 10 {  // not in a point
		i = -1
	}

	currentPoint = i
	libui.AreaQueueRedrawAll(histogram)
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

onDatapointChanged :: proc "c" (s: ^libui.Spinbox, data: rawptr) {
	libui.AreaQueueRedrawAll(histogram)
}

onColorChanged :: proc "c" (b: ^libui.ColorButton, data: rawptr) {
	libui.AreaQueueRedrawAll(histogram)
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
	o: libui.InitOptions
	brush: libui.DrawBrush

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

	mainwin = libui.NewWindow("libui Histogram Example", 640, 480, true)
	libui.WindowSetMargined(mainwin, true)
	libui.WindowOnClosing(mainwin, onClosing, nil)

	hbox := libui.NewHorizontalBox()
	libui.BoxSetPadded(hbox, true)
	libui.WindowSetChild(mainwin, cast(^libui.Control)hbox)

	vbox := libui.NewVerticalBox()
	libui.BoxSetPadded(vbox, true)
	libui.BoxAppend(hbox, cast(^libui.Control)vbox, false)

	for i in 0..<10 {
		rng := rand.int_max(101)
		datapoints[i] = libui.NewSpinbox(0, 100)
		libui.SpinboxSetValue(datapoints[i], auto_cast rng)
		libui.SpinboxOnChanged(datapoints[i], onDatapointChanged, nil)
		libui.BoxAppend(vbox, cast(^libui.Control)datapoints[i], false)
	}

	colorButton = libui.NewColorButton()
	setSolidBrush(&brush, colorDodgerBlue, 1.0)
	libui.ColorButtonSetColor(colorButton,
		brush.R,
		brush.G,
		brush.B,
		brush.A)
	libui.ColorButtonOnChanged(colorButton, onColorChanged, nil)
	libui.BoxAppend(vbox, cast(^libui.Control)colorButton, false)

	histogram = libui.NewArea(&handler)
	libui.BoxAppend(hbox, cast(^libui.Control)histogram, true)

	libui.ControlShow(cast(^libui.Control)mainwin)
	libui.Main()
	libui.Uninit()
}
