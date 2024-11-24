var lKey = keyboard_check( ord("A") ) || (gamepad_axis_value(4, gp_axislh) < -0.5)
var rkey = keyboard_check( ord("D") ) || (gamepad_axis_value(4, gp_axislh) > 0.5)
var spaceKey = keyboard_check_pressed( vk_space )	// pressed
var spaceKeyH = keyboard_check( vk_space )			// hold
var relSpaceKey = keyboard_check_released(vk_space)

var parasolKey = keyboard_check( vk_lshift )
var runKey = keyboard_check( vk_rshift )
var runKeyH = keyboard_check_released( vk_rshift )
var recordKey = keyboard_check_pressed( ord("E") )

var laKey = keyboard_check(vk_left) 
var raKey = keyboard_check(vk_right) 
var uaKey = keyboard_check(vk_up) 
var daKey = keyboard_check(vk_down)



var debugKey = keyboard_check_pressed( ord("T") )
if debugKey
{
	debugToggle = !debugToggle	
}


if xInput != 0 {
	t += 0.1;	
}
if (t > 1) t = 0;

// decrease timers
var dTime = delta_time / 1000;
cayoteTimer -= dTime;
bufferTimer -= dTime;
jumpTimer -= dTime;
fireTimer -= dTime;
wallJumpTimer -= dTime;


// Checks
isGrounded = place_meeting(x, y+1, oWall)



// Move inputs
xInput = rkey - lKey;
if canMove 
{
	// Old
	//xSpeed = xInput * moveSpeed; // For more precise gameplay
	//xSpeed = lerp(xSpeed, xInput * moveSpeed, .1); // For more smoothness

	var accelL = accelerationLeft;
	var accelR = accelerationRight;
	if !isGrounded // Air control
	{
		accelL = airTurnSpeed;
		accelR = airTurnSpeed
	}

	if !oParasol.isClosed // Parasol
	{
		accelL = glideTurnSpeed
		accelR = glideTurnSpeed
	}

	var targetSpeed = xInput * (moveSpeed + additionalMoveSpeed);
	if xSpeed < targetSpeed 
	{
		xSpeed += accelL;
		if (xSpeed > targetSpeed) xSpeed = targetSpeed
	}
	else if xSpeed > targetSpeed
	{
		xSpeed -= accelR;
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




// Running ---------------
if isGrounded {
	isRunning = runKey
	sprite_index = (runKey ? sPlayerDown : sPlayer)
}

if runKeyH {
	sprite_index = sPlayer
	isRunning = false
}


if isRunning // extra stats when running
{
	additionalMoveSpeed = (isGrounded) ? 1.65 : 3
	additionalJumpHeight = 2.5
	canGlide = false
	canWallJump = false
}
else 
{
	additionalJumpHeight = 0
	additionalMoveSpeed = 0	
	canGlide = true
	canWallJump = true
}




// Vertical movement ---- jumping
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
if isGrounded
{
	if isFalling
	{
		// Landed logic
		isRunning = false
	}
	
	cayoteTimer = cayoteTime
	isJumping = false
	jumpTimer = jumpTime
	isFalling = false
	oParasol.isClosed = true
}

// Jump
if (cayoteTimer > 0) && (bufferTimer > 0)
{
	ySpeed = -(jumpForceTap + additionalJumpHeight)
	isJumping = true;
	cayoteTimer = 0
	bufferTimer = 0
}

if isJumping && jumpTimer > 0 && spaceKeyH && !isRunning
{
	ySpeed += -jumpForce
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

if wallJumpDir[0] != 0 && !isGrounded && canWallJump
{	
	// Fuck gravity, (Turns upside down)
	if isFalling { 
		ySpeed /= counterUpForce
		isWallClimb = true
	}
	
	if spaceKey && wallJumpTimer <= 0
	{
		// Remove slowness from the Jump
		additionalMoveSpeed = 0
		
		// woowwiess perform a jump
		xSpeed += wallJumpDir[0] * wallJumpForce/2;
		ySpeed = wallJumpDir[1] * wallJumpForce;
		isJumping = true
		wallJumpTimer = wallJumpCooldown
	}	
}

if isGrounded || wallJumpDir[0] == 0 {
	isWallClimb = false
}
canMove = wallJumpTimer <= 0


// Clamp ySpeed to a certain fall speed
ySpeed = clamp(ySpeed, -100, maxFallSpeed)


// Collision checkin -------------------------------
// Collision checking (Horizontal)
var _subPixel = .1;
if place_meeting(x + xSpeed, y, oWall) 
{
	var _pixelCheck = _subPixel * sign(xSpeed)
	while !place_meeting(x+_pixelCheck, y, oWall)
	{
		x += _pixelCheck;
	}
	xSpeed = 0;
}

// Vertical collision
if place_meeting(x, y + ySpeed, oWall) 
{
	var _pixelCheck = _subPixel * sign(ySpeed);
	while !place_meeting(x, y+_pixelCheck, oWall)
	{
		y+=_pixelCheck;
	}
	ySpeed = 0;
}


// Extra info 
if ySpeed > 0 {
	isFalling = true	
	additionalGrav = .15
}
else if ySpeed <= 0 {
	isFalling = false	
	additionalGrav = 0
}


// Add forces to player
x += xSpeed;
y += ySpeed;







// ------------- Other mechanics --------------------

// Aiming
// record key press
if recordKey
{
	isRecording = !isRecording	
}

if !isRunning
{
	if raKey { lastDir = 2 }
	else if laKey { lastDir = 4 }
	else if uaKey { lastDir = 1 }
	else if daKey { lastDir = 3 }
	else { lastDir = 0 }	
}

if gamepad_is_connected(4)
{
	// controller (normalized already)
	var gpx = gamepad_axis_value(4, gp_axisrh);
	var gpy = gamepad_axis_value(4, gp_axisrv);
	
	rawDX = (gpx >= .5 || gpx <= -.5) ? gpx : 0
	rawDY = (gpy >= .5 || gpy <= -.5) ? gpy : 0
}
else // keyboard
{
	rawDX = raKey - laKey
	rawDY = daKey - uaKey	
}

// Apply Graphic Rotation on down look
var rot = 8
if (abs(rawDX) == 1 && abs(rawDY) == 1) { 
    // Diagonal movement
    Grot = lerp(Grot, (rawDX == rawDY ? -1 : 1) * rot, 0.5); 
} else {
    Grot = lerp(Grot, 0, 0.5);
}



// Normalize input for keyboard
if !gamepad_is_connected(4)
{
	var mag = sqrt(power(rawDX,2) + power(rawDY,2))
	if mag != 0
	{
		rawDX /= mag
		rawDY /= mag
	}	
}

// RawInputs are not allowed on run state
rawDX *= !isRunning
rawDY *= !isRunning

// No input
if rawDX == 0 && rawDY == 0
{
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



// Parasol
debugTxt = "isFalling: " + string(isFalling)
if canGlide
{
	if isFalling 
	{
		oParasol.isClosed = !parasolKey	
	}
	else {
		oParasol.isClosed = true	
	}

	if !oParasol.isClosed 
	{
		// remove any additional horizontal speed
		additionalMoveSpeed = 0
	}	
}
else
{
	oParasol.isClosed = true	
}
isGliding = !oParasol.isClosed


// Graphics related settings
SprCenter = y - (sprite_height/2)