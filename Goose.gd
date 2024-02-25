extends Node3D

func face_target(pos, weight):
	var rot = rotation
	# use look_at to look at the desired location
	look_at(pos)
	# cache the new "target" rotation
	var target_rot = rotation
	#use Quat.Slerp to perform spherical interpolation to the target rotation
	#a weight like 0.1 works well
	#then set the rotation by converting the Quat back to a Eule
	rotation.y = lerp_angle(rot.y, target_rot.y + PI/2, weight)
	rotation.x = rot.x
	rotation.z = rot.z
	

var player = null;
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Node3D/player")


func _process(delta):
	face_target(player.position, 0.05)
	
