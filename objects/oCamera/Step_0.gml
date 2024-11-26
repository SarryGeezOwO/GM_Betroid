if follow != noone
{
	xTo = follow.x + (oPlayer.isFacingRight ? xOffset : -xOffset)
	yTo = follow.y
}

if xTo+(camWidth/2) > roomBX
{
	xTo = roomBX - (camWidth/2)
}
else if xTo-(camWidth/2) < 0
{
	xTo = camWidth/2
}

if yTo+(camHeight/2) > roomBY
{
	yTo = roomBY - (camHeight/2)
}
else if yTo-(camHeight/2) < 0
{
	yTo = camHeight/2
}

x = lerp(x, xTo, followSpeed);
y = lerp(y, yTo, followSpeed);

camera_set_view_pos(
	view_camera[0], 
	floor(x-(camWidth*0.5)),
	floor(y-(camHeight*0.5))
)