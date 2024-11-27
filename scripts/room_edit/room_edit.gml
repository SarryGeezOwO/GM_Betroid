function open_room_data(file_name)
{
	if !file_exists(working_directory + file_name) {
		return
	}
	
	var file = file_text_open_read(working_directory + file_name)	
	var rW = file_text_read_real(file)
	var rH = file_text_read_real(file)
	file_text_readln(file)	
	file_text_readln(file)
	
	var objs = []
	while !file_text_eof(file)
	{
		var obi = file_text_read_string(file) // object index
		file_text_readln(file)	
		file_text_readln(file)	
		var _x = file_text_read_real(file)
		var _y = file_text_read_real(file)
		var _sx = file_text_read_real(file)
		var _sy = file_text_read_real(file)
		var _rot = file_text_read_real(file)
		file_text_readln(file)
		file_text_readln(file)
		array_push(objs, obi, _x, _y, _sx, _sy, _rot)
	}
	file_text_close(file)
	
	room_width = rW;
	room_height = rH;
	for (var i = 0; i < array_length(objs); i+=6)
	{
		var obi =	objs[i]
		var _x =	objs[i+1]
		var _y =	objs[i+2]
		var _sx =	objs[i+3]
		var _sy =	objs[i+4]
		var _rot =	objs[i+5]
		
		var instance = instance_create_layer(_x, _y, layer, asset_get_index(obi))
		instance.image_xscale = _sx
		instance.image_yscale = _sy
		instance.image_angle = _rot
	}
}

function save_current_room_data(file_name)
{
	var file = file_text_open_write(working_directory + file_name)
	file_text_write_real(file, room_width);	
	file_text_writeln(file)
	file_text_write_real(file, room_height);
	file_text_writeln(file)
	file_text_writeln(file)
	
	with all
	{
		if object_index == oRoomEdit
		{
			continue	
		}
		
		// Object type, object_category, x, y, scaleX, scaleY
		file_text_write_string(file, string(object_get_name(object_index)));	
			file_text_writeln(file)
		file_text_write_string(file, get_group_name(get_object_group(object_index)));	
			file_text_writeln(file)
		file_text_write_real(file, x)
			file_text_writeln(file)
		file_text_write_real(file, y)
			file_text_writeln(file)
		file_text_write_real(file, image_xscale)
			file_text_writeln(file)
		file_text_write_real(file, image_yscale)
			file_text_writeln(file)
		file_text_write_real(file, image_angle)
			file_text_writeln(file)
			file_text_writeln(file)
	}
	file_text_close(file)
	show_message("Room saved: ["+file_name+"]")
}