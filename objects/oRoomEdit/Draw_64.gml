function displayInfo(info = "", order = 0, isBottom = false)
{	
	// Let's just assum each letter has a 10 pixel width lol
	var _x = 5
	var _y = order*(isBottom ? -18 : 18);
	if isBottom
	{
		_y += display_get_gui_height()-20;	
	}
	
	draw_text(_x, _y, info)
}

function boolToString(i)
{
	return (i ? "true" : "false")
}

draw_set_color(c_white)
if selectedObject != noone
{
	displayInfo("Selected: " +	string(selectedObject.id), 0)
	displayInfo("x: " +			string(selectedObject.x), 1)
	displayInfo("y: " +			string(selectedObject.y), 2)
	displayInfo("scale x: " +	string(selectedObject.image_xscale), 3)
	displayInfo("scale y: " +	string(selectedObject.image_yscale), 4)
	displayInfo("rotation: " +	string(selectedObject.image_angle), 5)
}
else
{
	displayInfo("Selected: None", 0)
	displayInfo("x: -", 1)
	displayInfo("y: -", 2)
	displayInfo("scale x: -" , 3)
	displayInfo("scale y: -" , 4)
	displayInfo("rotation: -", 5)
}
displayInfo("Object: " + (currentObject == noone ? "None" : object_get_name(currentObject)), 7)

displayInfo("File: " + file_name_to_write, 0, true)
displayInfo("Zoom: " + string(round(zoomLevel*100))+"%", 1, true)
displayInfo("Mouse X: " + string(mouse_x), 2, true)
displayInfo("Mouse Y: " + string(mouse_y), 3, true)