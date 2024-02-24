extends OmniLight3D
var alpha = 0
var period = 678 
func _ready():
	visible = true

func _process(delta):
	alpha += delta
	visible = int(alpha * period) % period > period / 2
