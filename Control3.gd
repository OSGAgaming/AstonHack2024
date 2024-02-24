extends Control
@onready var button = $Quit;

# Called when the node enters the scene tree for the first time.
func _ready():
	button.position.x = 1800



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	button.position.x *= 0.92
	pass
