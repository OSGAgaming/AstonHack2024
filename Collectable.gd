extends MeshInstance3D

const description = "This is an item you can collect";
const outDescription = "You just collected this item";
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player != null:
		var distance = Global.player.transform.origin.distance_to(transform.origin);
		if distance < 5:
			Global.currentDescription = description;
			
