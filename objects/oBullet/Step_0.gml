x += dirX * spd
y += dirY * spd

if place_meeting(x, y, oWall) {
	instance_destroy(id, false)	
}
	