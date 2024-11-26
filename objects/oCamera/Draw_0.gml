draw_set_alpha(.25)
if isDebugMode()
{	
	draw_line(x-camWidth, y, x+camWidth, y)
	draw_line(x, y-camHeight, x, y+camHeight)
	draw_circle(x, y, 5, true)
}
draw_set_alpha(1)