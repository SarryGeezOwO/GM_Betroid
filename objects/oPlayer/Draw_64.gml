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
draw_text(20, 30, "isShooting: " + string(isShooting))
draw_text(20, 50, "is: " + string(isShooting))
draw_text(20, 70, "isShooting: " + string(isShooting))

draw_text(160, 10, debugTxt)
