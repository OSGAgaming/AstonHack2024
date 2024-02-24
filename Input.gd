extends LineEdit

@onready var canvas = get_node("/root/Node3D/CanvasLayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	grab_focus()


func _on_text_submitted(new_text):
	canvas.inputted_text = new_text
	canvas.sig_inputted_text.emit()
	clear()
