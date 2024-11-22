// Display Game info for debugging later
// all Game info will be displayed top right
var dpW = display_get_gui_width();
var dpH = display_get_gui_height();

function displayInfo(info = "", order = 1)
{	
	// Let's just assum each letter has a 10 pixel width lol
	var _x = display_get_gui_width() - string_length(info)*10
	draw_text(_x, order*17, info)
}

draw_set_color(c_white)
draw_set_alpha(1)

displayInfo("FPS: " + string(fps), 0)
displayInfo("GamePaused " + string(isGamePaused), 1)






// Game menu 
if isGamePaused
{
	var darkness = .5;
	draw_set_alpha(darkness)
	draw_set_color(c_black)
	draw_rectangle(0, 0, dpW, dpH, false)	
	
	// Draw or Spawn? I dont fucking know how to create UI yet for game maker studio lmao
}