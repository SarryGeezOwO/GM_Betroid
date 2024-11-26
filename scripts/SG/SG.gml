/// @Description 
///  Performs a raycast from a specified starting point in a given direction for a set length, 
///  checking for collisions with a specified object. The function returns information about the first object
///  it collides with along the ray, including the collision point and distance from the starting point.
///  If no collision occurs, it returns the endpoint of the ray.

function normalize_float(val, _min, _max)
{
	return (val - _min) / (_max - _min)	
}

function raycast(_x, _y, deg, len, obj, drawWidth = 1, draw = false, drawEmpty = false, color = c_white)
{
	var prevCol = draw_get_color()
	draw_set_color(color)
	
	if (len <= 0) return [_x, _y, 0, noone];
	if (obj == undefined) return [_x, _y, -1, noone];

	var collision_x = 0;
	var collision_y = 0;

	var dir = degree_to_unit_vector(deg)
	var hit = noone;
		
	for(var i = 0; i <= len; i++) 
	{
		var end_x = dir[0] * i + _x
		var end_y = dir[1] * i + _y
		
		var hitF = position_meeting(end_x, end_y-1, obj)
		if hitF {
			hit = instance_position(end_x, end_y-1, obj)
		    collision_x = end_x;
		    collision_y = end_y;
			break;	
		}
	}

	if hit != noone 
	{
		//draw_rectangle(hit.x, hit.y, collision_x, collision_y, true)
		
		var hit_dist = point_distance(_x, _y, collision_x, collision_y);
		if draw {
			draw_text(collision_x, collision_y+10, object_get_name(hit.object_index))
			draw_line_width(_x, _y, collision_x, collision_y, drawWidth)	
			draw_circle(collision_x-(dir[0]*5), collision_y-(dir[1]*5), 4, false)
			draw_set_color(prevCol)
		}
		
		return [collision_x, collision_y, hit_dist, hit.id, true]
		// x, y, dist, id, hitBool
	}
	else 
	{
		// Returns the farthest point
		if drawEmpty
		{
			draw_line_width(_x, _y, _x + len * dir[0], _y + len * dir[1], drawWidth)	
			draw_set_color(prevCol)	
		}
		return [_x + len * dir[0], _y + len * dir[1], -1, noone, false];
	}
}
