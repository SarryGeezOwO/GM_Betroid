sway_timer += sway_speed;
image_xscale = 1 + 0.1 * sin(sway_timer); // Oscillates the width for swaying effect


// Gradually restore the grass shape
image_xscale += (1 - image_xscale) * 0.1; // Smooth return to default size
