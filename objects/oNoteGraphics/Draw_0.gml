// Draw pointer
draw_set_color(c_yellow)

if noteIndex >= noteLimit || noteIndex == -1
{
	draw_line(x-15, y, x+15, y)
	draw_line(x-15, y-5, x-15, y+5)
	draw_line(x+15, y-5, x+15, y+5)
}



// Draw notes
for (var i = 0; i < noteLimit; i++)
{
	var n = notes[i]
	
	if n._x == -1
	{
		continue	
	}
	draw_sprite(noteSprites[n._x-1], 0, x+n._y, y)
}