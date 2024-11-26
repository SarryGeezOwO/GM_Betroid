var saveKey = keyboard_check_pressed( ord("S") )
var scaleXKey = keyboard_check_pressed( ord("K") )
var scaleYKey = keyboard_check_pressed( ord("L") )
var modifierKey = keyboard_check( vk_lcontrol )
var modifierAltKey = keyboard_check( vk_lalt )
var deleteKey = keyboard_check_pressed( vk_delete )

mX = floor(mouse_x/pixelSnap) * pixelSnap
mY = floor(mouse_y/pixelSnap) * pixelSnap

if saveKey && modifierKey
{
	// save all instance to a text file
	save_current_room_data(file_name_to_write)
}


if mouse_check_button_pressed(mb_left)
{	
	// check first if mouse collides with any object
	if position_meeting(mouse_x, mouse_y, all)
	{
		var obj = instance_position(mouse_x, mouse_y, all);
		// get that object	
		set_selected_object(obj)	
	}
	else { set_selected_object(noone) }	
}

if mouse_check_button_pressed(mb_right)
{
	var instance = instance_create_layer(mX, mY, layer, oWall)
	set_selected_object(instance)
}

if selectedObject != noone
{
	if deleteKey 
	{
		instance_destroy(selectedObject.id)
		set_selected_object(noone)
	}	
}

if modifierAltKey
{
	// increase scale
	if selectedObject != noone
	{
		if scaleXKey { selectedObject.image_xscale-- }
		if scaleYKey { selectedObject.image_yscale-- }
	}

	// ctrl + alt
	if modifierKey
	{
		if selectedObject != noone
		{
			selectedObject.x = mX;
			selectedObject.y = mY;
		}
	}
}
else
{
	// Decreasee scale
	if selectedObject != noone
	{
		if scaleXKey { selectedObject.image_xscale++ }
		if scaleYKey { selectedObject.image_yscale++ }
	}
}