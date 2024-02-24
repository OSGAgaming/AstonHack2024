extends Control
@onready var button = $Options;

# Called when the node enters the scene tree for the first time.
func _ready():
	button.position.x = 1200



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	button.position.x *= 0.92
	pass
