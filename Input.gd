extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	grab_focus()


func _on_text_submitted(new_text):
	clear()
