extends Node3D

var open = false
var originalCheesePosition = Vector3(-6.504, 125.452, 8.327)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player != null:
		var distance = Global.player.transform.origin.distance_to(transform.origin);
		if distance < 2:
			open = true
			$AnimationPlayer.play("Chest_0_A|Chest_0_AAction")
			await get_tree().create_timer(1.25).timeout
			$AnimationPlayer.seek(1.25)
			
		else:
			open = false
