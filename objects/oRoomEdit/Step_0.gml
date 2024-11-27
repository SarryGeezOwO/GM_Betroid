var saveKey = keyboard_check_pressed( ord("S") )
var deleteKey = keyboard_check_pressed( vk_delete )
modifierCtrlKey = keyboard_check( vk_lcontrol )
modifierAltKey = keyboard_check( vk_lalt )
modifierShiftkey = keyboard_check( vk_lshift )

var lKey = keyboard_check_pressed( vk_left )
var rKey = keyboard_check_pressed( vk_right )
var uKey = keyboard_check_pressed( vk_up )
var dKey = keyboard_check_pressed( vk_down )

mX = floor(mouse_x/pixelSnap) * pixelSnap
mY = floor(mouse_y/pixelSnap) * pixelSnap

if saveKey && modifierCtrlKey
{
	// save all instance to a text file
	save_current_room_data(file_name_to_write)
}


if mouse_check_button_pressed(mb_left) && !modifierCtrlKey && !modifierAltKey && !modifierShiftkey
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

if mouse_check_button_pressed(mb_right) && !modifierCtrlKey && !modifierAltKey && !modifierShiftkey
{
	if currentObject != noone {
		var instance = instance_create_layer(mX, mY, layer, currentObject)
		set_selected_object(instance)	
	}
	else { set_selected_object(noone) }	
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
	// Increase Scale
	if selectedObject != noone && !modifierCtrlKey && !modifierShiftkey
	{
		if uKey { 
			selectedObject.image_yscale++ 
			selectedObject.y -= pixelSnap
		}
		if dKey { selectedObject.image_yscale++ }
		if lKey { 
			selectedObject.image_xscale++ 
			selectedObject.x -= pixelSnap
		}
		if rKey { selectedObject.image_xscale++ }
	}
	
	// Inverse Scale
	if selectedObject != noone && modifierShiftkey && !modifierCtrlKey
	{
		if uKey { 
			selectedObject.image_yscale--
			selectedObject.y += pixelSnap
		}
		if dKey { selectedObject.image_yscale-- }
		if lKey { 
			selectedObject.image_xscale--
			selectedObject.x += pixelSnap
		}
		if rKey { selectedObject.image_xscale-- }	
	}

	// ctrl + alt (move object position)
	if modifierCtrlKey && !modifierShiftkey
	{
		if selectedObject != noone
		{
			selectedObject.x = mX;
			selectedObject.y = mY;
		}
	}
}

if modifierShiftkey
{
	// Rotate
	if modifierCtrlKey && selectedObject != noone
	{
		if mouse_check_button(mb_left)
		{
			var _x = selectedObject.x;
			var _y = selectedObject.y;
			var angle = get_vector_normalized(_x, _y, mouse_x, mouse_y)
			selectedObject.image_angle = unit_vector_to_degree(angle[0], angle[1])		
		}
		if uKey { selectedObject.image_angle += 20 }
		if dKey	{ selectedObject.image_angle -= 20 }
	}
	
	// Object picker
	var move = (rKey - lKey) * (!modifierAltKey * !modifierCtrlKey);
	var len = array_length(placableObjects)
	currentObjectIndex += move
	
	if currentObjectIndex < 0		{ currentObjectIndex = len - 1 }
	if currentObjectIndex >= len	{ currentObjectIndex = 0 }
	
	var str = string_copy(placableObjects[currentObjectIndex], 2, string_length(placableObjects[currentObjectIndex])-1);
	if str != "None" {
		currentObjectSprite = asset_get_index("s"+str)
		currentObject = asset_get_index("o"+str)	
	}
	else
	{
		currentObjectSprite = noone
		currentObject = noone
	}
}


// Turn on all Invinsible Object into a visible type
with all 
{
	visible = true	
}