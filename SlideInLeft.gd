extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var margin_value = 	1000
	add_theme_constant_override("margin_left", margin_value)	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var margin_value = 	get_theme_constant("margin_left") * 0.98
	add_theme_constant_override("margin_left", margin_value)	
