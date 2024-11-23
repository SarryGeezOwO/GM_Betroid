x = oPlayer.x-(oPlayer.isFacingRight ? -15 : 15);
y = oPlayer.y-(oPlayer.sprite_height/2) - (len-2)

time += 0.025;
if (time > 1) time = 1-.25;

var fv = (oPlayer.isFacingRight ? .25 : -.25)
var mx = fv;
var my = -1;
var l = sqrt(power(mx, 2) + power(my, 2))
if l != 0 {
	udir[0] = mx/l	
	udir[1] = my/l
}

spHX = -udir[0]*(len-7)+x
spHY = -udir[1]*(len-7)+y
startPoint[0] = -udir[0]*len+x;
startPoint[1] = -udir[1]*len+y;

endPoint[0] = udir[0]*len+x;
endPoint[1] = udir[1]*len+y;


// Transition
if isClosed
{
	pLenLerp = 5
	perpEndPoint[0] = lerp(perpEndPoint[0], spHX, .65)
	perpEndPoint[1] = lerp(perpEndPoint[1], spHY, .65)
	oPlayer.Grot = lerp(oPlayer.Grot, 0, .65)
	
	timer -= delta_time/1000
}
else 
{
	timer = 300 // milliseconds
	
	pLenLerp = pLenOpen	
	perpEndPoint[0] = lerp(perpEndPoint[0], endPoint[0], .5)
	perpEndPoint[1] = lerp(perpEndPoint[1], endPoint[1], .5)
	oPlayer.ySpeed = clamp(oPlayer.ySpeed, -100, oPlayer.glideFallSpeed)
	
	var rot = (oPlayer.isFacingRight ? 23 : -23)
	oPlayer.Grot = lerp(oPlayer.Grot, rot, .25)
}

pLen = lerp(pLen, pLenLerp, .2)	
stopDrawing = timer <= 0
