function DebugMode (flag)
{
	draw_set_color(flag ? c_red : c_white)
}


// Draw aim assist for debugging
function debugAimAssist() {
	DebugMode(true)
	draw_set_alpha(.3)
	for (var i = -assistDegree; i <= assistDegree; i++)
	{	
		var a = i
		var radA = degtorad(a)
	
		var pX = rawDX * cos(radA) - rawDY * sin(radA)
		var pY = rawDX * sin(radA) + rawDY * cos(radA)
		draw_line(x, y-(sprite_height/2), pX*maxDistance+newDX, pY*maxDistance+newDY)
	}
	
	draw_set_color(c_white)
	draw_set_alpha(1)	
	draw_line_width(x, y-(sprite_height/2), rawDX*maxDistance+x, rawDY*maxDistance+(y-(sprite_height/2)), 2)
	
	if rawDX != 0 || rawDY != 0 {
		draw_set_color(c_red)
		draw_line_width(newDX, newDY, pointDirX*maxDistance+newDX, pointDirY*maxDistance+newDY, 2)
		
		raycast(
			newDX, newDY, 
			unit_vector_to_degree(dX, dY),
			maxDistance, oWall, 2, true, true, c_blue
		)
	}
	DebugMode(false)
}
debugAimAssist()



//var centerY = y-(sprite_height/2)
var centerY = bbox_top + (bbox_bottom - bbox_top) / 2;



// Is moving animation
var arcHeight = 8;
var offset = sin(t * pi) * arcHeight;
if xInput == 0 || isJumping
{
	offset = 0
}
else {
	offset -= 4
}
spriteYOffset = lerp(spriteYOffset, -offset, .2)
var xScale = (isFacingRight ? 1 : -1)

if isRecording {
	
	var timeC = current_time / 60.0;
	var texR = 1.0 * sin(timeC + 0.0);
	var texG = 0.5 * sin(timeC + 0.2);
	var texB = 1.0 * sin(timeC + 0.4);
	
	// Draw outline for recording
	draw_sprite_ext(
		sprite_index, image_index, 
		x, (y+spriteYOffset)+outline_offset*2, 
		xScale*outline_offset,
		outline_offset, 
		0, make_color_rgb(texR*255, texG*255, texB*255), image_alpha
	)	
}


// Draw hand
draw_set_color(make_color_rgb(141, 199, 63))
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
draw_set_color(make_color_rgb(141, 199, 63))

/* Advance hand
var angle = (arctan2(dY, dX) / pi) * 180
if dX != 0 || dY != 0 
{
	//draw_sprite_ext(sHand, 0, newDX, newDY, 1, (sign(dX) == 0 ? 1 : sign(dX)), -angle, c_white, 1)		
}
*/


// Procedural
// Draw all bodies
	
// Tail outline	
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
	
		arcHeight = bodies[i].weight / i
		offset = sin(t * pi) * arcHeight;	
	
		if xInput == 0 || isJumping
		{
			offset = 0
		}
		else {
			offset -= arcHeight/2
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
for (var i = 0; i < bodyCount; i++) 
{
	var xx = bodies[i].posX;
	var yy = bodies[i].posY;
	
	var prev = bodies[0]
	if i > 0 {
		prev = bodies[i-1]
	}
	
	arcHeight = bodies[i].weight / i
	offset = sin(t * pi) * arcHeight;	
	
	if xInput == 0 || isJumping
	{
		offset = 0
	}
	else {
		offset -= arcHeight/2
	}
	
	draw_set_color(make_color_rgb(141, 199, 63))
	draw_circle(xx, yy-offset, bodies[i].weight, false);
	//draw_line(xx, yy, prev.posX, prev.posY)
}



// Draw the actual player
draw_sprite_ext(sprite_index, image_index, x, y+spriteYOffset, xScale, 1, 0, c_white, image_alpha) 


DebugMode(false)

// Draw foot
draw_circle(leftFoot.posX, leftFoot.posY, leftFoot.weight, false)
draw_circle(rightFoot.posX, rightFoot.posY, rightFoot.weight, false)

// Draw legs
draw_line_width(x-2, y-5, leftFoot.posX, leftFoot.posY, 4)
draw_line_width(x+2, y-5, rightFoot.posX, rightFoot.posY, 4)




