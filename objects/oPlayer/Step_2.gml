/// @description Stuffs that are miscellaneous such as graphics and sounds


// Procedural Feets ---------------------------------
var centerY = y-(sprite_height/2)
var moveFeet = function (_lx, _ly, _rx, _ry) 
{
	leftFoot.posX = _lx;
	leftFoot.posY = _ly;
	rightFoot.posX = _rx;
	rightFoot.posY = _ry;
}
var lStepOffset = 2;
var rStepOffset = 9;

var rstepRestOffset = 6;

if isRunning
{
	rstepRestOffset = 12
	rightFoot.distance = 19
	rStepOffset += 9
}
else 
{
	rstepRestOffset = 6
	rightFoot.distance = 10
}

var newLeftPosX = x+ ((isFacingRight) ? -lStepOffset : lStepOffset)
var newRightPosX = x+ ((isFacingRight) ? rStepOffset : -rStepOffset)
if current_time - footTime > 250 
{
	// reset	
	leftLerpX = newLeftPosX
	rightLerpX = x+ ((isFacingRight) ? rstepRestOffset : -rstepRestOffset)
	leftFoot.posY = y-3;
	rightFoot.posY = y-3;
	footTime = current_time
}

if GetLen(x,leftLerpX,y,leftFoot.posY) > leftFoot.distance
{
	leftLerpX = newLeftPosX;
	footTime = current_time
}

if GetLen(x,rightLerpX,y,rightFoot.posY) > rightFoot.distance
{
	rightLerpX = newRightPosX;
	footTime = current_time
}

var lX = leftFoot.posX
var lY = leftFoot.posY
var rX = rightFoot.posX
var rY = rightFoot.posY

if GetLen(lX,leftLerpX,lY,lY) <= .25
{
	turn = 0
}
else if GetLen(rX,rightLerpX,rY,rY) <= .25
{
	turn = 1	
}

// Constantly move feet to lerp
if turn == 1 // left
{
	leftFoot.posX = leftLerpX
}
else // right
{
	rightFoot.posX = rightLerpX
}
leftFoot.posY = y - leftFoot.weight
rightFoot.posY = y - rightFoot.weight


// Foot position on air
if !isGrounded
{
	moveFeet(x-2, y+leftFoot.weight-2, x+2, y+rightFoot.weight-2)
}

// Foot position on wall
if isWallClimb
{
	var xOfst = -wallJumpDir[0] * ((sprite_width/2) + 2)
	moveFeet(
		x+xOfst, centerY+2,
		x+xOfst, centerY+10
	)
}





// Procedural Tail -----------------
var _subPixel = .25
var bTop = bodies[bodyCount-1]
var offsetY = (isWallClimb ? 13 : 6)
offsetY = (isRunning ? 3 : offsetY)

var offsetX = (isFacingRight) ? -4 : 4;
offsetX = (isJumping || isWallClimb) ? 0 : offsetX
offsetX = (isRunning) ? ((isFacingRight) ? -10 : 10) : offsetX

var x2 = x+offsetX;
var y2 = SprCenter+offsetY;

var vec = get_vector_normalized(bTop.posX, bTop.posY, x2, y2)
bTop.posX = x2 - vec[0] * bTop.distance;
bTop.posY = y2 - vec[1] * bTop.distance;

for (var i = bodyCount-2; i >= 0; i--) 
{	
	var b = bodies[i]
	var prev = bodies[i+1]
	
	// Apply gravity
	var realGrav = (xInput == 0 || !isGrounded) ? bodyGrav : .35;
	if !place_meeting(b.posX, b.posY+b.weight+realGrav, oWall)
	{
		b.posY += realGrav	
	}
	else 
	{
		var _pixelCheck = _subPixel * sign(b.posY+b.weight+realGrav)
		while !place_meeting(b.posX, b.posY+b.weight+_pixelCheck, oWall)
		{
			b.posY += _pixelCheck;
		}	
	}
	
	var len = GetLen(b.posX, prev.posX, b.posY, prev.posY)
	if len <= b.distance {
		continue	
	}

	vec = get_vector_normalized(b.posX, b.posY, prev.posX, prev.posY)
	b.posX = prev.posX - vec[0] * b.distance;
	b.posY = prev.posY - vec[1] * b.distance;
}




// Play pipe sound on fall damage ------------------
if ySpeed >= fallDamageHeightThreshold
{
	playFallSound = true	
}

if playFallSound && isGrounded {
	audio_play_sound(snd_metal_pipe, 0, false, 1, .25)	
	playFallSound = false
}


