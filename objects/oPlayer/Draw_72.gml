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



// Dust effect on run
part_type_direction(part_run_trail, 0, 90, 0, 2)
if isRunning && isGrounded
{
	var px = isFacingRight ? 5 : -5
	part_particles_create(run_part_sys, x+px, y-3, part_run_trail, 5) // bottom		
}
