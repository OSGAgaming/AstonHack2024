extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/VBoxContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/VBoxContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label

var tween : Tween = Tween.new()
enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	hide_textbox()
	queue_text("Excuse me wanderer where can I find the bathroom?")
	queue_text("Why do we not look like the others?")
	queue_text("Because we are free assets from opengameart!")
	queue_text("Thanks for watching!")

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			label.visible_ratio += delta
			if Input.is_action_just_pressed("ui_accept") or label.visible_ratio >= 1:
				label.visible_ratio = 1.0
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()

func change_state(next_state):
	current_state = next_state

func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(State.FINISHED)
