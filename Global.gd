extends Node

enum GameState {
	MainMenu,
	GameplayReady,
	Gameplay
}
var gameState = GameState.MainMenu;
var focused = false;
var transitionAlpha = 0;
var player = null;

var inspecting = false;
var inspectionID = -1;

var currentDescription = "";
var currentItem = "";

var noOfItemsCollected = 0;

