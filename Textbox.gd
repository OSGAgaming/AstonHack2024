extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/End
@onready var label = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var requestManager = $HTTPRequest
@onready var input_txtBox = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/Panel/InputContainer/LineEdit

signal sig_inputted_text
var inputted_text = ""

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	hide_textbox()
	if true:
		goose_talk()

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty() && !Global.isGameMenu:
				display_text()
		State.READING:
			label.visible_ratio += delta
			if Input.is_action_just_pressed("Enter") or label.visible_ratio >= 1:
				label.visible_ratio = 1.0
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("Enter"):
				change_state(State.READY)
				hide_textbox()

func goose_talk():
	requestManager.prompt()
	await requestManager.request_completed
	queue_text(requestManager.prev_response)
	input_txtBox.grab_focus()
	await sig_inputted_text
	requestManager.send_message("SYSTEM: Begin asking questions about the gameshow. Treat the following as if the user had just inputted: " + inputted_text)
	await requestManager.request_completed
	
	while(true):
		await get_tree().create_timer(1.0).timeout
		requestManager.send_message(inputted_text)
		await requestManager.request_completed
		queue_text(requestManager.prev_response)
		print("Goose:", requestManager.prev_response)
		input_txtBox.grab_focus()
		await sig_inputted_text
	

func queue_text(next_text):
	Global.focused = true
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
	if next_state == State.FINISHED:
		input_txtBox.grab_focus()
	current_state = next_state
