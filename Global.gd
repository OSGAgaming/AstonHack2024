extends Node

enum GameState {
	MainMenu,
	GameplayReady,
	Gameplay
}
var gameState = GameState.MainMenu;
var focused = false;
var transitionAlpha = 0;
