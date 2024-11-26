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
leftFoot.distance = isFacingRight ? 10 : 6

var rstepRestOffset = 6;

if isRunning
{
	rstepRestOffset = 13
	rightFoot.distance = 19
	rStepOffset += 9
}
else 
{
	rstepRestOffset = 6
	rightFoot.distance = 10
}

var newLeftPosX = x+ ((isFacingRight) ? lStepOffset : -lStepOffset)
var newRightPosX = x+ ((isFacingRight) ? rStepOffset+1 : -rStepOffset)
if current_time - footTime > 60 
{
	// reset	
	leftLerpX = x+ ((isFacingRight) ? lStepOffset-5 : -lStepOffset+5)
	rightLerpX = x+ ((isFacingRight) ? rstepRestOffset : -rstepRestOffset)
	leftFoot.posY = y-leftFoot.weight;
	rightFoot.posY = y-rightFoot.weight;
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
var arcHeight = 2;
if turn == 1 // left
{
	leftFoot.posX = leftLerpX
	
	if xInput != 0
	{
		var arcOffset = sin(t * pi) * arcHeight;
		leftFoot.posY = lerp(leftFoot.posY, y - (arcOffset + leftFoot.weight), t)	
	}
	else { leftFoot.posY = y - leftFoot.weight }
}
else // right
{
	rightFoot.posX = rightLerpX
	
	if xInput != 0
	{
		var arcOffset = sin((t+0.5) * pi) * arcHeight;
		rightFoot.posY = lerp(rightFoot.posY, y - (arcOffset + rightFoot.weight), t)	
	}
	else { rightFoot.posY = y - rightFoot.weight }
}


// Foot position on air
if !isGrounded
{
	var m = isFacingRight ? 1 : -1
	if isRunning
	{
		moveFeet(x-(2*m), y-2, x+(10*m), y-2)	
	}
	else 
	{
		moveFeet(x-(2*m), y-2, x+3*m, y-2)	
	}
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


