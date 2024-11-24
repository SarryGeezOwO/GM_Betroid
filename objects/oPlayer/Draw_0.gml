function DebugMode (flag)
{
	draw_set_color(flag ? c_red : c_white)
}

// Draw aim assist for debugging
function debugAimAssist() {
	DebugMode(true)
	draw_set_alpha(.1)
	for (var i = -assistDegree; i <= assistDegree; i++)
	{	
		var a = i
		var radA = degtorad(a)
	
		var pX = rawDX * cos(radA) - rawDY * sin(radA)
		var pY = rawDX * sin(radA) + rawDY * cos(radA)
		draw_line_width(newDX, newDY, pX*maxDistance+newDX, pY*maxDistance+newDY, 10)
	}
	
	draw_set_color(c_ltgray)
	draw_set_alpha(.3)
	draw_line_width(newDX, newDY, rawDX*maxDistance+newDX, rawDY*maxDistance+newDY, 3)
	draw_set_alpha(1)

	if rawDX != 0 || rawDY != 0 {
		draw_set_color(c_red)
		draw_line_width(newDX, newDY, pointDirX*maxDistance+newDX, pointDirY*maxDistance+newDY, 3)
		
		raycast(
			newDX, newDY, 
			unit_vector_to_degree(dX, dY),
			maxDistance, [oDummy, oWall], 3, true, true, c_lime
		)
	}	

	DebugMode(false)
}


function debugPlayerMove(ofst)
{
	len = array_length(movePoints);
	array_push(movePoints, new Vector(x, (y-(sprite_height/2))+ofst))
	draw_set_color(c_ltgray)
	
	for (var i = 1; i < len; i++)
	{
		vec = movePoints[i]
		vecPrev = movePoints[i-1]
		draw_line(vecPrev.pX, vecPrev.pY, vec.pX, vec.pY)
	}
	
	if len >= 100
	{
		array_delete(movePoints, 0, 1)
	}
	
	// Draw colliders / hitbox
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true)
}


if !isRecording
{
	if debugToggle 
	{
		debugAimAssist()	
	}
}
//draw_line_width(newDX, newDY, pointDirX*maxDistance+newDX, pointDirY*maxDistance+newDY, 3)


var centerY = y-(sprite_height/2)
//var centerY = bbox_top + (bbox_bottom - bbox_top) / 2;



// Is moving animation
var arcHeight = 8;
var offset = sin(t * pi) * arcHeight;
if xInput == 0 || isJumping || !oParasol.isClosed
{
	offset = 0
}
else {
	offset -= arcHeight/2
}
spriteYOffset = lerp(spriteYOffset, -offset, .2)
var xScale = (isFacingRight ? 1 : -1)



if isRecording {
	
	var timeC = current_time / 60.0;
	var texR = 1.0 * sin(timeC + 0.0);
	var texG = 0.5 * sin(timeC + 0.2);
	var texB = 1.0 * sin(timeC + 0.4);
	
	// Draw body outline for recording
	draw_sprite_ext(
		sprite_index, image_index, 
		x, (y+spriteYOffset)+outline_offset*2, 
		xScale*outline_offset,
		outline_offset, 
		image_angle+Grot, make_color_rgb(texR*255, texG*255, texB*255), image_alpha
	)	
}




// Procedural
// Draw all bodies
	
// Tail outline	
var tailFreq = .5;
arcHeight = 1.5
if isRecording
{
	for (var i = 0; i < bodyCount; i++) 
	{
		var xx = bodies[i].posX;
		var yy = bodies[i].posY;
	
		var prev = bodies[0]
		if i > 0 {
			prev = bodies[i-1]
		}
	
		offset = sin(t*(i*tailFreq) * pi) * arcHeight;	
		if xInput == 0 || isJumping
		{
			offset = 0
		}
		else {
			offset += arcHeight/2
		}
	
	
		// Draw outline
		var timeC = current_time / 60.0;
		var texR = 1.0 * sin(timeC + 0.0);
	    var texG = 0.5 * sin(timeC + 0.2);
	    var texB = 1.0 * sin(timeC + 0.4);
		draw_set_color(make_color_rgb(texR*255, texG*255, texB*255))
		draw_circle(xx, (yy-offset), bodies[i].weight+outline_offset_tail, false);
	}
}

// Actual tail (superbly bad code, lmao, absolutely destroying the D.R.Y principle loooll
draw_set_color(greenCol)
for (var i = 0; i < bodyCount; i++) 
{
	var xx = bodies[i].posX;
	var yy = bodies[i].posY;
	
	var prev = bodies[0]
	if i > 0 {
		prev = bodies[i-1]
	}
	
	offset = sin(t*(i*tailFreq) * pi) * arcHeight;	
	if xInput == 0 || isJumping
	{
		offset = 0
	}
	else {
		offset += arcHeight/2
	}
	draw_circle(xx, yy-offset, bodies[i].weight, false);
	//draw_line(xx, yy, prev.posX, prev.posY)
}




// Draw hand
draw_set_color(greenCol)
//var lerpFactor = (isRecording ? .35 : .45)
var lerpFactor = clamp(
	(point_distance(x,centerY, rawDX, rawDY) - 15) / 15, 0, 1) * (isRecording ? .3 : .65);
newDX = lerp(newDX, x+(dX*17), lerpFactor)
newDY = lerp(newDY, centerY+(dY*17), lerpFactor)

draw_circle(newDX, newDY, 3, false)
draw_line_width(x, centerY, newDX, newDY, 4)

// Draw stick lmao
if dX != 0 || dY != 0 
{
	draw_set_color(c_white)
	var tipX = newDX + (dX*10)
	var tipY = newDY + (dY*10)
	draw_line_width(newDX, newDY, tipX, tipY, 3)
}
draw_set_color(greenCol)

/* Advance hand
var angle = (arctan2(dY, dX) / pi) * 180
if dX != 0 || dY != 0 
{
	//draw_sprite_ext(sHand, 0, newDX, newDY, 1, (sign(dX) == 0 ? 1 : sign(dX)), -angle, c_white, 1)		
}
*/




// Draw the actual player
if debugToggle debugPlayerMove(spriteYOffset)
draw_sprite_ext(sprite_index, image_index, x, y+spriteYOffset, xScale, 1, image_angle+Grot, c_white, image_alpha) 



DebugMode(false)
// Draw foot
draw_circle(leftFoot.posX, leftFoot.posY, leftFoot.weight, false)
draw_circle(rightFoot.posX, rightFoot.posY, rightFoot.weight, false)

DebugMode(false)
// Draw legs
draw_line_width(x-2, y-5, leftFoot.posX, leftFoot.posY, 4)
draw_line_width(x+2, y-5, rightFoot.posX, rightFoot.posY, 4)






/*
with oDummy
{		
	var eX = x - oPlayer.x
	var eY = (y-sprite_height/2) - (oPlayer.y-(oPlayer.sprite_height/2))
	var dist = sqrt(power(eX,2) + power(eY,2))
	
	// Ignore targets above max range
	if dist >= oPlayer.maxDistance
	{
		continue	
	}
	
	if dist != 0
	{
		eX /= dist
		eY /= dist
		
		draw_line(oPlayer.x, oPlayer.y-(oPlayer.sprite_height/2), x, y-(sprite_height/2))
		var wallCheck = raycast(
			oPlayer.x, oPlayer.y-(oPlayer.sprite_height/2),
			unit_vector_to_degree(eX, eY),
			oPlayer.maxDistance, [id, oWall],
			1, true, true, c_lime
		)
		
		if wallCheck[4] {
			if wallCheck[3].object_index == oWall
			{
				continue
			}
		}
		
		draw_text(200, 30, 
			string(eX) + " : " + string(eY)
		)
	}	
}
*/
