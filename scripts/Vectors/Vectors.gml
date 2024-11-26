function degree_to_unit_vector(deg) {
    var rad = degtorad(deg); // Convert degrees to radians
    return [cos(rad), -sin(rad)];
}



/// The unit vector provided should be normalized, duh
function unit_vector_to_degree(_x, _y) {
    return -(arctan2(_y, _x) / pi) * 180;
}


/// Returns an array with 2 length, representing a vector x and y value
/// @param arr = an array with a 2 length representing the x and y value of a vector
function normalize_vector_arr(arr)
{
	var newX = arr[0]
	var newY = arr[1]
	
	var mag = sqrt(power(newX,2) + power(newY,2))

	if mag != 0
	{
		newX /= mag
		newY /= mag
	}
	
	return [newX, newY]
}

function normalize_vector(_x, _y)
{
	var newX = _x
	var newY = _y
	
	var mag = sqrt(power(newX,2) + power(newY,2))

	if mag != 0
	{
		newX /= mag
		newY /= mag
	}
	
	return [newX, newY]
}



function get_vector(x1, y1, x2, y2)
{
	var newX = x2 - x1;
	var newY = y2 - y1;
	return [newX, newY]
}


function get_vector_normalized(x1, y1, x2, y2)
{
	var newX = x2 - x1;
	var newY = y2 - y1;
	return normalize_vector(newX, newY)
}



function scale_vector_by_length(vector, desiredLength)
{
	var mag = sqrt(power(vector[0],2) + power(vector[1],2))
	if mag != 0
	{
		return [
			vector[0] * (desiredLength / mag),
			vector[1] * (desiredLength / mag)
		]
	}
	
	return [0, 0]
}


function add_length_to_vector(vector, additiveLength)
{
	// add the scaled to the original vector
	var vec = scale_vector_by_length(vector, additiveLength) // get the scaled version
	return [vector[0]+vec[0], vector[1]+vec[1]]
}



function scale_position_by_vector(unitVec, length, position)
{
	return [
		unitVec[0]*length+position[0],
		unitVec[1]*length+position[1]
	]	
}