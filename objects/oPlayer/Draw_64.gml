/// @description Direction Aim GUI
draw_set_color(c_yellow)
draw_set_alpha(1)

// DX and DY is a unit vector
// it only records the direction
// needs to be offset relative to the base circle

var yoffset = 110
var xoffset = 65

GDX = lerp(GDX, rawDX, .45)
GDY = lerp(GDY, rawDY, .45)

draw_circle(xoffset, yoffset, 40, true)
draw_circle(GDX*40+xoffset, GDY*40+yoffset, 20, false)

var text = ""
if lastDir == 1 { text = "Up" }
else if lastDir == 2 { text = "Right" }
else if lastDir == 3 { text = "Down" }
else if lastDir == 4 { text = "Left" }
else { text = "None" }

draw_text(20, 10, text)
draw_text(20, 30, "shooting: " + string(isShooting))

draw_text(160, 10, debugTxt)


draw_set_alpha(.2)
draw_set_color(c_white)
// Grid settings
var grid_size = 32;  // The size of each grid square (adjust to your needs)

// Draw the horizontal grid lines
for (var i = 0; i <= room_height; i += grid_size) {
    draw_line(0, i, room_width, i);  // Draw a line from left to right at this y position
}

// Draw the vertical grid lines
for (var j = 0; j <= room_width; j += grid_size) {
    draw_line(j, 0, j, room_height);  // Draw a line from top to bottom at this x position
}
draw_set_alpha(1)
