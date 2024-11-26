camWidth = 1280; // The resolution of room not the window
camHeight = 720;
roomBX = room_width
roomBY = room_height

surface_resize(application_surface, camWidth+1, camHeight+1)
application_surface_draw_enable(false)

follow = oPlayer;

followSpeed = .025;
xOffset = 60

xTo = y;
yTo = x;