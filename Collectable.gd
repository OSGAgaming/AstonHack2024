extends MeshInstance3D

const description = "Looks like an id card";
const outDescription = "You just picked up an id card with your \n
Name: woiuhgwergrwef \n 
Date Of Birth: 05-04-1999"

var within = false;
var time = 0;
var initY = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.currentItem == outDescription:

		Global.inspectionID = 0;
		time += delta
		if time > 3:
			Global.transitionAlpha *= 0.9

			if Global.transitionAlpha < 0.1:

				Global.currentItem = ""
				Global.inspectionID = -1;
				queue_free()
		else:
			Global.transitionAlpha += (0.8 - Global.transitionAlpha) / 16

	if Global.player != null:
		var distance = Global.player.transform.origin.distance_to(transform.origin);
		if distance < 2 and visible:
			if not within:
				Global.currentDescription = description;
			within = true
			if Input.is_action_just_pressed("Enter"):
				Global.inspecting = true;
				Global.currentItem = outDescription
				visible = false
		else:
			if within:
				Global.currentDescription = "";
			within = false
			
