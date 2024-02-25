extends Node3D

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player != null:
		var distance = Global.player.transform.origin.distance_to(transform.origin);
		if distance < 2 and open == false:
			$AnimationPlayer.play("Chest_0_A|Chest_0_AAction")
