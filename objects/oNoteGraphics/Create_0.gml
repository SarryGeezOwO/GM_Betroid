yOffset = 20
prevInput = -1
playerInput = -1
// 0 = none
// 1 = top
// 2 = right
// 3 = down
// 4 = left

var Vec2 = function(_xx, _yy) constructor
{
	_x = _xx;
	_y = _yy;
}

// Notes:
// C, C#, D, D#, E, F, F#, G, G#, A, A#, B
// Starter notes: C E G

// Note vector labels
// x = type
// y = (x offset)
noteIndex = -1
noteLimit = 3
notes = [
	new Vec2(-1, -10),
	new Vec2(-1, 0),
	new Vec2(-1, 10)
]