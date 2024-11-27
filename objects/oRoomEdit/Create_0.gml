file_name_to_write = "Test_Room.txt"
selectedObject = noone;

modifierCtrlKey = 0
modifierAltKey = 0
modifierShiftkey = 0

currentObjectIndex = 0
currentObject = oWall
currentObjectSprite = sWall

placableObjects = tag_get_assets("Placeable")
array_push(placableObjects, "-None")

// Objects like, oGameHandler, oParasol, oNoteGraphics are placed automatically as they're invinsible anyways

camX = -50
camY = -50
moveSpd = 10

minZoom = 800
maxZoom = 3000
zoomAmount = 10
zoomLevel = 0 // normal value

pixelSnap = 32
mX = 0
mY = 0

function set_selected_object(object)
{		
	selectedObject = object;
	if object == noone
	{
		return	
	}
}

// Open file 
open_room_data(file_name_to_write)