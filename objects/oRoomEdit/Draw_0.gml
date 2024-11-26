// Draw grid
draw_set_color(c_white)
draw_set_alpha(.1)

// Vertical lines
for (var i = 0; i <= room_width; i+=pixelSnap)
{
	draw_line(i, 0, i, room_height)
}

// Horizontal lines
for (var j = 0; j <= room_height; j+=pixelSnap)
{
	draw_line(0, j, room_width, j)
}

draw_set_alpha(1)

// Draw room borders
draw_set_color(c_olive)
draw_line_width(0, 0, room_width, 0, 2)
draw_line_width(0, 0, 0, room_height, 2)
draw_line_width(0, room_height, room_width, room_height, 2)
draw_line_width(room_width, 0, room_width, room_height, 2)
draw_set_color(c_white)


// Draw current selected object (Ghost)
if currentObjectSprite != noone
{
	draw_sprite_ext(
		currentObjectSprite, -1,
		mX, mY,
		1, 1,
		0, c_white, .35
	)	
}

// Draw mouse cell
draw_rectangle(mX, mY, mX+pixelSnap, mY+pixelSnap, true)


// Draw selected Object rect
if selectedObject != noone
{
	draw_set_color(c_aqua)
	var sX = selectedObject.bbox_left;
	var sY = selectedObject.bbox_top;
	var sW = selectedObject.bbox_right;
	var sH = selectedObject.bbox_bottom;
	draw_line_width(sX, sY, sW, sY, 2) // top
	draw_line_width(sX, sY, sX, sH, 2) // left
	draw_line_width(sX, sH, sW, sH, 2) // bottom
	draw_line_width(sW, sY, sW, sH, 2) // right	
	draw_set_color(c_white)
	
	// Draw origin point
	draw_circle(sX, sY, 3, false)
}