extends Control
@onready var button = $Play;

# Called when the node enters the scene tree for the first time.
func _ready():
	button.position.x = 600



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if 	Global.gameState == Global.GameState.MainMenu:
		button.position.x += (-20 - button.position.x) / 16
	else:
		button.position.x += (600 - button.position.x) / 16

