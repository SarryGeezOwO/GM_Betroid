// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
var isGamePaused = false

function Pause() {
	isGamePaused = true;	
}

function Resume() {
	isGamePaused = false;	
}

function setDebugMode(flag)
{
	oGamehandler.debugMode = flag	
}

function isDebugMode()
{
	return oGamehandler.debugMode	
}