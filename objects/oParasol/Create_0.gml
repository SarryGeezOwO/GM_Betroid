isClosed = true
prevClosed = true
stopDrawing = false
timer = 0

// Head
perpEndPoint = [0, 0]
pLenOpen = 25
pLenLerp = 15
pLen = 0
tlen = 15

time = 0

// Body
spHX = 0
spHY = 0

len = 10
startPoint = [500, 500]
endPoint = [700, 300]
udir = [1, 1]


// Particle trail wind
part_sys = part_system_create();
part_trail = part_type_create();

part_system_depth(part_sys, 20)
part_type_shape(part_trail, pt_shape_cloud); 
part_type_size(part_trail, 0.05, .25, 0, .2);  
part_type_alpha3(part_trail, .5, 0.25, 0);   
part_type_life(part_trail, 15, 35);