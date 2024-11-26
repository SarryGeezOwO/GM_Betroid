// Graphics settings
Grot = 0; // graphics rotation in degrees
greenCol = make_color_rgb(141, 199, 63)
SprCenter = 0


// Movement
canMove = true
xInput = 0;
moveSpeed = 3.25;
// Don't ask about this acceleration system
accelerationLeft = .65;	// speed turn (Left)
accelerationRight = .65;	// speed turn (Right)
xSpeed = 0;
ySpeed = 0;
grav = .5;
additionalGrav = 0
additionalMoveSpeed = 0
isFacingRight = true;
maxFallSpeed = 20;



// Running
canRun = true
isRunning = false
runSpeed = 5
isLeaping = false


// Jumping
canJump = true
additionalJumpHeight = 0
jumpForceTap = 3.6
maxJumpHeight = 5.5
cayoteTime = 120
bufferTime = 100
cayoteTimer = 0
bufferTimer = 0
isJumping = false
isGrounded = false
isFalling = false
jumpTimer = 0
jumpTime = 220
airTurnSpeed = 1;


// Wall Jumping
// Wall jumps are not the same as normal jumping,
// it has a constant force rather than an incremental force
canWallJump = false
isWallClimb = false
wallJumpCooldown = 50; // milliseconds
wallJumpTimer = -1;
counterUpForce = 2; // the amount to divide in ySpeed, lower faster fall
wallJumpForce = 9
leftWallCheck = false
rightWallCheck = false
wallJumpDir = [0, 0] // x, y
// direction is based on the two wall checks
// inverted direction of where the wall checked
// leftWall = 1
// rightWall = -1


// Double jumping



// Gliding
canGlide = true;
isGliding = false;
glideTurnSpeed = .25;
glideFallSpeed = .1 // .1


// Misc.
fallDamageHeightThreshold = 15
playFallSound = false



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
assistDegree = 10
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
trail_part_sys = part_system_create();
part_trail = part_type_create();
part_type_shape(part_trail, pt_shape_cloud); // Shape of the particle
part_type_size(part_trail, 0.05, .1, 0, .15);   // Size variation
part_type_alpha3(part_trail, 1, 0.5, 0);    // Fading effect
part_type_life(part_trail, 0, 30);         // Lifespan in frames


// Run effect
run_part_sys = part_system_create();
part_run_trail = part_type_create();
part_type_shape(part_run_trail, pt_shape_cloud); // Shape of the particle
part_type_size(part_run_trail, 0.075, .15, -.01, .125);   // Size variation
part_type_alpha3(part_run_trail, 1, 0.5, 0);    // Fading effect
part_type_life(part_run_trail, 5, 25);         // Lifespan in frames


// Procedural animation
spriteYOffset = 0
bodyGrav = 1.25

Body = function(w, d) constructor {
	weight = w;
	distance = d;
	posX = 0;
	posY = 0;
}

bodyCount = 7;
bodies = [
	new Body(3, 1), // End of tail
	new Body(4, 2),
	new Body(3, 2),
	new Body(4, 4),
	new Body(5, 4),
	new Body(6, 4),
	new Body(6, 2), // attached to player
]

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
leftFoot = new Body(4, 10)
rightFoot = new Body(4, 10)



// Debugging
movePoints = []