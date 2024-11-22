var menuKey = keyboard_check_pressed( vk_escape )

if menuKey {
	if isGamePaused Resume()
	else Pause()
}