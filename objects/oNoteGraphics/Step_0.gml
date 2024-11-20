x = oPlayer.x
y = oPlayer.y - oPlayer.sprite_height - yOffset

prevInput = playerInput

var ld = oPlayer.lastDir;
if playerInput != ld
{
	playerInput = ld
}

if !oPlayer.isRecording
{
	// Empty bucket
	notes[0]._x = -1
	notes[1]._x = -1
	notes[2]._x = -1
	noteIndex = -1
}

// Spawn a note once
if prevInput != playerInput && oPlayer.isRecording
{
	var flag = false
	if playerInput != 0 {
		if noteIndex < noteLimit-1
		{
			noteIndex++	
		}
		else if noteIndex == noteLimit-1
		{
			notes[0]._x = -1	
			notes[1]._x = -1
			notes[2]._x = -1
			noteIndex++
			flag = true
		}
		else 
		{
			noteIndex = 0	
		}
		
		if !flag
		{
			notes[noteIndex]._x = playerInput	
		}
	}
}