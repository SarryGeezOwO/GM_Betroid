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
var newLeftPosX = x+ ((isFacingRight) ? -2 : 2)
var newRightPosX = x+ ((isFacingRight) ? 8 : -8)
if current_time - footTime > 250 
{
	// reset	
	leftLerpX = newLeftPosX
	rightLerpX = x+ ((isFacingRight) ? 5 : -5)
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

if GetLen(lX,leftLerpX,lY,lY) <= 1
{
	turn = 0
}
else if GetLen(rX,rightLerpX,rY,rY) <= 1
{
	turn = 1	
}

// Constantly move feet to lerp
if turn == 1 // left
{
	//leftFoot.posX = lerp(leftFoot.posX, leftLerpX, .85)
	leftFoot.posX = leftLerpX
}
else // right
{
	//rightFoot.posX = lerp(rightFoot.posX, rightLerpX, .85)	
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
var len = GetLen(bTop.posX, x, bTop.posY, y)
var lerp_factor = clamp((len - bTop.distance) / bTop.distance, 0, 1) * 0.5;
var offsetY = (isWallClimb ? 5 : 10)
var offsetX = (isFacingRight) ? -2 : 2
offsetX = (isJumping || isWallClimb) ? 0 : offsetX 

if len > bTop.distance
{
	bTop.posX = lerp(bTop.posX, x+offsetX, lerp_factor);
	bTop.posY = lerp(bTop.posY, y-offsetY, lerp_factor);
}

for (var i = bodyCount-2; i >= 0; i--) 
{	
	var b = bodies[i]
	var prev = bodies[i+1]
	
	// Apply gravity
	var realGrav = (xInput == 0 || !isGrounded) ? bodyGrav : .5;
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
	
	len = GetLen(b.posX, prev.posX, b.posY, prev.posY);
	if len <= b.distance
	{
		continue
	}

	lerp_factor = clamp((len - b.distance) / b.distance, 0, 1) * 0.5; 
	b.posX = lerp(b.posX, prev.posX, lerp_factor);
	b.posY = lerp(b.posY, prev.posY, lerp_factor);
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