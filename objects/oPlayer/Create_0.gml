// Movement
canMove = true
xInput = 0;
moveSpeed = 4.15;
// Don't ask about this acceleration system
accelerationX = .7;	// speed turn (Left)
deccelerationX = .7;	// speed turn (Right)
xSpeed = 0;
ySpeed = 0;
grav = .4;
additionalGrav = 0
isFacingRight = true;

// TODO: Make tail more beautiful

// Jumping
canJump = true
jumpForceTap = 4
jumpForce = .585
cayoteTime = 120
bufferTime = 140
cayoteTimer = 0
bufferTimer = 0
isJumping = false
isGrounded = false
isFalling = false
jumpTimer = 0
jumpTime = 200



// Wall Jumping
// Wall jumps are not the same as normal jumping,
// it has a constant force rather than an incremental force
canWallJump = false
isWallClimb = false
wallJumpCooldown = 50; // milliseconds
wallJumpTimer = -1;
counterUpForce = 1.5; // the amount to divide in ySpeed, lower faster fall
wallJumpForce = 9
leftWallCheck = false
rightWallCheck = false
wallJumpDir = [0, 0] // x, y
// direction is based on the two wall checks
// inverted direction of where the wall checked
// leftWall = 1
// rightWall = -1


// Aiming And Hand
rawDX = 0
rawDY = 0
dX = 0 // Raw X
dY = 0 // Raw Y
newDX = 0 // HandGraphics
newDY = 0 // HandGraphics
GDX = 0 // GUI
GDY = 0 // GUI

debugTxt = ""
assistDegree = 30
maxDistance = 800
bestScore = -1
pointDirX = 0
pointDirY = 0

lastDir = -1
// 0 = none
// 1 = top
// 2 = right
// 3 = down
// 4 = left


// shooting / Recording
// Continously shoot whenever the direction is not 'none'
canShoot = false
isRecording = false
isShooting = false
shootDelay = 250
fireRate = 500 // milliseconds, duh
fireTimer = 0
bulletSpeed = 20

// recording effect
outline_offset_tail = 2; // additive
outline_offset = 1.2; // Controls the outline size

part_sys = part_system_create();
part_trail = part_type_create();


part_type_shape(part_trail, pt_shape_flare); // Shape of the particle
part_type_size(part_trail, 0.05, .1, 0, .15);   // Size variation
part_type_alpha3(part_trail, 1, 0.5, 0);    // Fading effect
part_type_life(part_trail, 0, 30);         // Lifespan in frames



// Procedural animation
spriteYOffset = 0
bodyGrav = .6

Body = function(w, d) constructor {
	weight = w;
	distance = d;
	posX = 0;
	posY = 0;
}

Vector = function(_x, _y) constructor {
	pX = _x;
	pY = _y;
}

bodyCount = 6;
bodies = [
	new Body(2, 2),
	new Body(3, 3),
	new Body(4, 5),
	new Body(5, 5),
	new Body(6, 5),
	new Body(7, 2),
]

GetLen = function(x1, x2, y1, y2) 
{
	d1 = x2-x1;
	d2 = y2-y1;
	return sqrt(power(d1, 2) + power(d2, 2))
}

GetDir = function(x1, x2, y1, y2)
{
	d1 = x2 - x1;
	d2 = y2 - y1;
	l = sqrt(power(d1, 2) + power(d2, 2))
	if l != 0 
	{
		d1 /= l
		d2 /= l
	}
	return new Vector(d1, d2);
}

// inital positions
for(var i = 0; i < bodyCount; i++) 
{
	bodies[i].posX = x;
	bodies[i].posY = y;
}


// Feet procedural
footTime = 0
leftLerpX = 0
rightLerpX = 0
t = 0
turn = 0
leftFoot = new Body(3, 10)
rightFoot = new Body(3, 10)



// Debugging
movePoints = []