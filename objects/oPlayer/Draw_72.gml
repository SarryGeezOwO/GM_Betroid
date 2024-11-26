var partCol = make_color_rgb(
	irandom_range(225, 255),
	irandom_range(50, 255),
	irandom_range(0, 100)
)

part_type_color1(part_trail, partCol);
if isRecording && (rawDX != 0 || rawDY != 0)
{
	// Trail VFX
	var tipX = newDX + (dX*15)
	var tipY = newDY + (dY*15)
	part_particles_create(trail_part_sys, tipX, tipY, part_trail, 5);	
}


/*
// Effect sliding on wall
var brn = irandom_range(150, 255);
part_type_color1(part_wall_trail, make_color_rgb(brn, brn, brn))
var px = (!isFacingRight ? bbox_left-2 : bbox_right+2)
if (leftWallCheck) && !isGrounded
{
	if position_meeting(bbox_left-2, y, oWall)
	{
		part_particles_create(wall_part_sys, px, y-3, part_wall_trail, 2) // bottom
	}
}
else if (rightWallCheck) && !isGrounded
{
	if position_meeting(bbox_right+2, y, oWall)
	{
		part_particles_create(wall_part_sys, px, y-3, part_wall_trail, 2) // bottom
	}
}
*/



// Dust effect on run
part_type_direction(part_run_trail, 0, 90, 0, 2)
if isRunning && isGrounded
{
	var px = isFacingRight ? 5 : -5
	part_particles_create(run_part_sys, x+px, y-3, part_run_trail, 5) // bottom		
}
