extends Sprite2D

var rotationalVel
var positionVel;

var activate = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	rotationalVel = 0
	positionVel = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.inspectionID == 3:
		var center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
		positionVel.x += (center.x - position.x) / 128 - positionVel.x/10
		positionVel.y += (center.y - position.y) / 128 - positionVel.y/10
		
		position += positionVel
		
		rotationalVel += (0.2 - rotation) / 100 - rotationalVel/20

		
		rotation += rotationalVel
	else:	
		position.x += (-300 - position.x) / 16
		rotation *= 0.95
	pass
