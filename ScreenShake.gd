extends Camera3D

var strength = 20
@onready var rng = RandomNumberGenerator.new()
var shakeDecay = 0.96
var shakeStrength
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shakeStrength = Global.screenShake
	Global.screenShake *= shakeDecay
	var rand = randOffset()
	h_offset = rand.x
	v_offset = rand.y

	
func applyShake():
	shakeStrength = strength

func randOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), 
	rng.randf_range(-shakeStrength, shakeStrength))
