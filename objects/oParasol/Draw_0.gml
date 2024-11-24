var nA = timer/300

draw_set_alpha(nA)
if nA <= 0 {
	draw_set_alpha(1)
	return	
}


// Body
draw_set_color(make_color_rgb(176, 141, 87))
draw_line_width(startPoint[0], startPoint[1], endPoint[0], endPoint[1], 2)
draw_rectangle(startPoint[0]-2, startPoint[1]-2, startPoint[0]+2, startPoint[1]+2, false)

var scaledEP = scale_position_by_vector(udir, 1.5, endPoint)
draw_circle(scaledEP[0], scaledEP[1], 3, false)

// udir stands for the direction of the parasol is pointing to

// Head
var p1 = [ // Right end point of the perpendicular line
	udir[0]-pLen*udir[1]+perpEndPoint[0],
	udir[1]+pLen*udir[0]+perpEndPoint[1]
]

var p2 = [ // Left end point of the perpendicular line
	udir[0]-(-pLen)*udir[1]+perpEndPoint[0],
	udir[1]+(-pLen)*udir[0]+perpEndPoint[1]
]

var mp = scale_position_by_vector(udir, tlen, endPoint)


// Wind effect
if !isClosed 
{
	part_particles_create(part_sys, endPoint[0], endPoint[1], part_trail, 1);	
}


// background
matrix_set(matrix_world, matrix_build_identity()) // reset for no wierd transformations
draw_triangle(p1[0], p1[1], p2[0], p2[1], mp[0], mp[1], false) // to hide shit

draw_set_color(make_color_rgb(212, 196, 179))
var _uv = sprite_get_uvs(sParasolTex, 0)

vertex_format_begin();
vertex_format_add_position();
vertex_format_add_color()
vertex_format_add_texcoord();
var vFormat = vertex_format_end();

var vbuffer = vertex_create_buffer();
vertex_begin(vbuffer, vFormat)

// Add the vertices to the buffer
vertex_position(vbuffer, p1[0], p1[1]);
vertex_color(vbuffer, draw_get_color(), draw_get_alpha());
vertex_texcoord(vbuffer, _uv[0], _uv[1])

vertex_position(vbuffer, mp[0], mp[1]);
vertex_color(vbuffer, draw_get_color(), draw_get_alpha());
vertex_texcoord(vbuffer, _uv[0], _uv[3])

vertex_position(vbuffer, p2[0], p2[1]);
vertex_color(vbuffer, draw_get_color(), draw_get_alpha());
vertex_texcoord(vbuffer, _uv[2], _uv[3])

vertex_end(vbuffer);
vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(sParasolTex, 0))

vertex_delete_buffer(vbuffer)
vertex_format_delete(vFormat)



// points and line

draw_set_color(make_color_rgb(156, 121, 67))
draw_circle(p1[0], p1[1], 2, false) // Right end
draw_circle(p2[0], p2[1], 2, false) // Left end
draw_circle(mp[0], mp[1], 2, false) // mid point


draw_line_width(p1[0], p1[1], mp[0], mp[1], 1)
draw_line_width(p2[0], p2[1], mp[0], mp[1], 1)
draw_line_width(p1[0], p1[1], p2[0], p2[1], 1)


// Draw inner moving lines
for (var i = 0; i < 1; i += .25)
{
	var ed = [
		p1[0]+(time-i)*(p2[0]-p1[0]),
		p1[1]+(time-i)*(p2[1]-p1[1])
	]
	draw_circle(ed[0], ed[1], 2, false)	
	draw_line(ed[0], ed[1], mp[0], mp[1])
}


// Draw player hands
draw_set_color(oPlayer.greenCol)
draw_line_width(oPlayer.x, oPlayer.SprCenter, spHX, spHY, 5)
draw_circle(spHX, spHY, 3, false)

// Reset for other draw events
draw_set_alpha(1)