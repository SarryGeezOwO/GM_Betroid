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
	part_particles_create(part_sys, tipX, tipY, part_trail, 5);	
}

// TODO:
// Make aim assist more advance as this is an important feature after all