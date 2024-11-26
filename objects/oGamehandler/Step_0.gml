
var menuKey = keyboard_check_pressed( vk_escape )
var debugKey = keyboard_check_pressed( ord("T") )
if debugKey
{
	setDebugMode(!debugMode)	
}

if menuKey {
	if isGamePaused Resume()
	else Pause()
}