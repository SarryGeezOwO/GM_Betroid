var lKey = keyboard_check( ord("A") )
var rkey = keyboard_check( ord("D") )
var spaceKey = keyboard_check_pressed( vk_space )	// pressed
var spaceKeyH = keyboard_check( vk_space )			// hold
var relSpaceKey = keyboard_check_released(vk_space)

var recordKey = keyboard_check_pressed( ord("E") )

var laKey = keyboard_check(vk_left)
var raKey = keyboard_check(vk_right)
var uaKey = keyboard_check(vk_up)
var daKey = keyboard_check(vk_down)

t += 0.05;
if (t > 1) t = 0;

// decrease timers
var dTime = delta_time / 1000;
cayoteTimer -= dTime;
bufferTimer -= dTime;
jumpTimer -= dTime;
fireTimer -= dTime;
wallJumpTimer -= dTime;


// Move inputs
xInput = rkey - lKey;
if canMove 
{
	// Old
	//xSpeed = xInput * moveSpeed; // For more precise gameplay
	//xSpeed = lerp(xSpeed, xInput * moveSpeed, .1); // For more smoothness

	var targetSpeed = xInput * moveSpeed;
	if xSpeed < targetSpeed 
	{
		xSpeed += accelerationX;
		if (xSpeed > targetSpeed) xSpeed = targetSpeed
	}
	else if xSpeed > targetSpeed
	{
		xSpeed -= deccelerationX;
		if (xSpeed < targetSpeed) xSpeed = targetSpeed
	}
}

// Adjust face direction
if xInput > 0 && !isFacingRight {
	isFacingRight = !isFacingRight	
}
else if xInput < 0 && isFacingRight {
	isFacingRight = !isFacingRight
}

// Collision checking (Horizontal)
var _subPixel = .5;
if place_meeting(x + xSpeed, y, oWall) 
{
	var _pixelCheck = _subPixel * sign(xSpeed)
	while !place_meeting(x+_pixelCheck, y, oWall)
	{
		x += _pixelCheck;
	}
	xSpeed = 0;
}


// Vertical movement
ySpeed += (grav + additionalGrav);	

// Jump buffering
if spaceKey && canJump
{
	bufferTimer = bufferTime	
}

if relSpaceKey || jumpTimer <= 0
{
	isJumping = false	
}

// Cayote Time (Ground check)
isGrounded = place_meeting(x, y+1, oWall)
if isGrounded
{
	cayoteTimer = cayoteTime
	isJumping = false
	jumpTimer = jumpTime
	isFalling = false
}

// Jump
if (cayoteTimer > 0) && (bufferTimer > 0)
{
	ySpeed += -jumpForceTap
	isJumping = true;
	cayoteTimer = 0
	bufferTimer = 0	 
}

if isJumping && jumpTimer > 0 && spaceKeyH
{
	ySpeed += -jumpForce
}

if place_meeting(x, y + ySpeed, oWall) 
{
	var _pixelCheck = _subPixel * sign(ySpeed);
	while !place_meeting(x, y+_pixelCheck, oWall)
	{
		y+=_pixelCheck;
	}
	ySpeed = 0;
}



// Wall jumping
// You can only jump when wallJumpDir.x does not have a magnitude of 0
var centerY = y-sprite_height/2;
var xOffset = sprite_width/2;
leftWallCheck = (
	position_meeting((x-xOffset)-3, centerY-6, oWall)	|| 
	position_meeting((x-xOffset)-3, centerY,   oWall)	||
	position_meeting((x-xOffset)-3, centerY+6, oWall)
)
rightWallCheck = (
	position_meeting((x+xOffset)+3, centerY-6, oWall) ||
	position_meeting((x+xOffset)+3, centerY,   oWall) ||
	position_meeting((x+xOffset)+3, centerY+6, oWall)
)

wallJumpDir[0] = leftWallCheck - rightWallCheck // in this case it's inverted
wallJumpDir[1] = -1 // modify this if you want to idk
wallJumpDir = normalize_vector_arr(wallJumpDir)

if wallJumpDir[0] != 0 && !isGrounded
{	
	// Fuck gravity, (Turns upside down)
	if isFalling { 
		ySpeed /= counterUpForce
		isWallClimb = true
	}
	
	if spaceKey && wallJumpTimer <= 0
	{
		// woowwiess perform a jump
		xSpeed += wallJumpDir[0] * wallJumpForce/2;
		ySpeed = wallJumpDir[1] * wallJumpForce;
		wallJumpTimer = wallJumpCooldown
	}	
}

if isGrounded || wallJumpDir[0] == 0 {
	isWallClimb = false
}
canMove = wallJumpTimer <= 0


// Extra info 
if ySpeed > 0 {
	isFalling = true	
}
else if ySpeed <= 0 {
	isFalling = false	
}


// Add forces to player
x += xSpeed;
y += ySpeed;


// ------------- Other mechanics

// Aiming
// record key press
if recordKey
{
	isRecording = !isRecording	
}

if raKey { lastDir = 2 }
else if laKey { lastDir = 4 }
else if uaKey { lastDir = 1 }
else if daKey { lastDir = 3 }
else { lastDir = 0 }

rawDX = raKey - laKey
rawDY = daKey - uaKey
var mag = sqrt(power(rawDX,2) + power(rawDY,2))
if mag != 0
{
	rawDX /= mag
	rawDY /= mag
}
else {
	// Meaning there is no input (aka length 0)
	fireTimer = shootDelay
}

// Aim assist
dX = rawDX;
dY = rawDY;

var dp_threshold = cos(degtorad(assistDegree))
var hit = false
with oDummy
{
	if oPlayer.isRecording
	{
		continue	
	}
	
	if oPlayer.rawDX == 0 && oPlayer.rawDY == 0
	{
		continue	
	}
	
	
	var eX = x - oPlayer.x
	var eY = (y-sprite_height/2) - (oPlayer.y-(oPlayer.sprite_height/2))
	var dist = sqrt(power(eX,2) + power(eY,2))
	
	// Ignore targets above max range
	if dist >= oPlayer.maxDistance
	{
		continue	
	}
	
	if dist != 0
	{
		eX /= dist
		eY /= dist
		
		var wallCheck = raycast(
			oPlayer.x, oPlayer.y-(oPlayer.sprite_height/2),
			unit_vector_to_degree(eX, eY),
			oPlayer.maxDistance, [id, oWall]
		)
		
		if wallCheck[4]
		{	
			// the raycast will both check oDummy and oWall,
			// check if the ray hits a wall first
			if wallCheck[3].object_index == oWall
			{
				continue
			}
		}
		
		var normDist = 1 - (dist / oPlayer.maxDistance);
		var dp = (oPlayer.dX * eX) + (oPlayer.dY * eY)
	
		// Ignore enemies outside of the assistDegree
		if dp < dp_threshold
		{
			continue
		}
		
		var w1 = 0.5;
		var w2 = dp;
	
		var _score = w1 * normDist + w2 * dp
		if _score > oPlayer.bestScore
		{
			hit = true
			oPlayer.bestScore = _score
			oPlayer.pointDirX = eX;
			oPlayer.pointDirY = eY;
		}
	}	
}
if !hit 
{	
	// No enemy spotted
	pointDirX = 0
	pointDirY = 0
}
else 
{
	// ENEMY SPOTTED!!!!
	dX = pointDirX;
	dY = pointDirY;
}
bestScore = -1 // reset



// Shooting
isShooting = ((dX != 0) || (dY != 0)) && !isRecording
if isShooting && fireTimer <= 0 && canShoot
{	
	// Spawn bullet, yipiee
	var tipX = newDX + (dX*10)
	var tipY = newDY + (dY*10)
	var instance = instance_create_layer(tipX, tipY, layer, oBullet)
	
	var bAngle = unit_vector_to_degree(dX, dY)
	instance.dirX = dX;
	instance.dirY = dY;
	instance.spd = bulletSpeed
	instance.angle = bAngle
	fireTimer = fireRate
}



// Procedural Feets 
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


// Procedural Tail
var bTop = bodies[bodyCount-1]
var len = GetLen(bTop.posX, x, bTop.posY, y)
var lerp_factor = clamp((len - bTop.distance) / bTop.distance, 0, 1) * 0.5;
var offsetY = 10
var offsetX = (isFacingRight) ? -2 : 2
offsetX = (isJumping) ? 0 : offsetX 
if len > bTop.distance
{
	bTop.posX = lerp(bTop.posX, x+offsetX, lerp_factor);
	bTop.posY = lerp(bTop.posY, y-offsetY, lerp_factor);
}
else if len <= bTop.distance
{
	//Apply gravity when not moving
	if !place_meeting(bTop.posX, bTop.posY+grav, oWall) && !isJumping
	{
		bTop.posY += bodyGrav;	
	}
}

for (var i = bodyCount-2; i >= 0; i--) 
{
	var b = bodies[i]
	var prev = bodies[i+1]
	len = GetLen(b.posX, prev.posX, b.posY, prev.posY);
	if len <= b.distance + 0.5
	{
		if !place_meeting(b.posX, b.posY+b.weight+grav, oWall) && !isJumping
		{
			b.posY += bodyGrav	
		}
	}
	if len <= b.distance
	{
		continue
	}

	lerp_factor = clamp((len - b.distance) / b.distance, 0, 1) * 0.5; 
	b.posX = lerp(b.posX, prev.posX, lerp_factor);
	b.posY = lerp(b.posY, prev.posY, lerp_factor);
}

