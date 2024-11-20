// Draw pointer
draw_set_color(c_yellow)

if noteIndex >= noteLimit || noteIndex == -1
{
	draw_line(x-15, y, x+15, y)
	draw_line(x-15, y-5, x-15, y+5)
	draw_line(x+15, y-5, x+15, y+5)
}



// Draw notes
var spriteIndexOffset = 3
for (var i = 0; i < noteLimit; i++)
{
	var n = notes[i]
	
	if n._x == -1
	{
		continue	
	}
	draw_sprite(n._x+spriteIndexOffset, 0, x+n._y, y)
}