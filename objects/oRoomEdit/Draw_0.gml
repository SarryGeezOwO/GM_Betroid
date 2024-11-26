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
draw_sprite_ext(
	sWall, 0,
	mX, mY,
	1, 1,
	0, c_white, .35
)

// Draw mouse cell
draw_rectangle(mX, mY, mX+pixelSnap, mY+pixelSnap, true)


// Draw selected Object rect
if selectedObject != noone
{
	draw_set_color(c_aqua)
	var sX = selectedObject.x;
	var sY = selectedObject.y;
	var sW = selectedObject.image_xscale * pixelSnap;
	var sH = selectedObject.image_yscale * pixelSnap;
	draw_line_width(sX, sY, sX+sW, sY, 2) // top
	draw_line_width(sX, sY, sX, sY+sH, 2) // left
	draw_line_width(sX, sY+sH, sX+sW, sY+sH, 2) // bottom
	draw_line_width(sX+sW, sY, sX+sW, sY+sH, 2) // right
	//draw_rectangle(sX, sY, sX+sW, sY+sH, true)	
	draw_set_color(c_white)
}