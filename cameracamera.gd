extends Camera3D
# oops ignore what this is called i am bad at 
# thinking of things to call things

var lens = null
func _ready():
	lens = get_parent().get_parent().get_node("lens")

func _process(delta):
	position = lens.global_position
	rotation = lens.global_rotation
	rotate_y(PI/2)
