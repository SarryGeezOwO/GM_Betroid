// Display Game info for debugging later
// all Game info will be displayed top right
var dpW = display_get_gui_width();
var dpH = display_get_gui_height();

function displayInfo(info = "", order = 1)
{	
	// Let's just assum each letter has a 10 pixel width lol
	var _x = display_get_gui_width() - string_length(info)*10
	draw_text(_x, order*18, info)
}

function boolToString(i)
{
	return (i ? "true" : "false")
}

draw_set_color(c_white)
draw_set_alpha(1)

displayInfo("FPS: " + string(fps_real) + " || " + string(fps), 0)
displayInfo("GamePaused " + boolToString(isGamePaused), 1)
displayInfo("DebugMode: " + boolToString(debugMode), 2)
displayInfo("CamX: " + string(oCamera.x), 3)
displayInfo("CamY: " + string(oCamera.y), 4)


if isDebugMode()
{
	draw_set_alpha(0.1)
	draw_set_color(c_lime)
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
	draw_set_color(c_white)
}
draw_set_alpha(1)





// Game menu 
if isGamePaused
{
	var darkness = .5;
	draw_set_alpha(darkness)
	draw_set_color(c_black)
	draw_rectangle(0, 0, dpW, dpH, false)	
	
	// Draw or Spawn? I dont fucking know how to create UI yet for game maker studio lmao
}