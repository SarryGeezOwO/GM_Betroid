// Move camera
var lKey = keyboard_check( vk_left )
var rKey = keyboard_check( vk_right )
var uKey = keyboard_check( vk_up )
var dKey = keyboard_check( vk_down )

x += (rKey - lKey) * moveSpd
y += (dKey - uKey) * moveSpd
camera_set_view_pos(view_camera[0], x, y)


// zooming
var zoomInKey = keyboard_check(ord("O"));
var zoomOutKey = keyboard_check(ord("P"));

var zoomChange = (zoomOutKey - zoomInKey) * zoomAmount;

var camW = camera_get_view_width(view_camera[0]);
var camH = camera_get_view_height(view_camera[0]);

// maintain aspect ratio (L:ratio)
var aspectRatio = camW / camH;

// Apply zoom change
camW += zoomChange;
camH = camW / aspectRatio;

// Clamp zoom values
camW = clamp(camW, minZoom, maxZoom);
camH = camW / aspectRatio;

zoomLevel = normalize_float(camW, minZoom, maxZoom)

// Apply the new size to the camera
camera_set_view_size(view_camera[0], camW, camH);

