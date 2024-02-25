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
var overshoot = 0
var prev_answer = ""

enum text_State {
	READY,
	READING,
	FINISHED
}
enum goose_State {
	WELCOME,
	QUESTION1,
	ANS_QUESTION1,
	QUESTION2,
	ANS_QUESTION2,
	QUESTION3,
	RESULTS
}

var text_current_state = text_State.READY
var goose_current_state = goose_State.WELCOME
var text_queue = []

var honks = [
	preload("res://assets/honk/honk1.wav"),
	preload("res://assets/honk/honk2.wav"),
	preload("res://assets/honk/honk3.wav"),
	preload("res://assets/honk/honk4.wav"),
	preload("res://assets/honk/honk5.wav")
	]

func playsound():
		$AudioStreamPlayer2D.stream = honks.pick_random()
		$AudioStreamPlayer2D.play()

func should_playsound():
	var text = label.text
	var index = floor(label.visible_ratio * len(text))
	if index >= len(text):
		index = len(text) - 1
	return text[index] in [ "a", "e", "i", "o", "u"]

func _ready():
	hide_textbox()

	if true:
		goose_talk()

func _process(delta):
	match text_current_state:
		text_State.READY:
			if !text_queue.is_empty() && Global.gameState == Global.GameState.Gameplay:
				label.text = ""
				display_text()
				overshoot = 50
				textbox_container.position.y += (1000 - textbox_container.position.y) / 5
			else:
				textbox_container.position.y += (1000 - textbox_container.position.y) / 5
		text_State.READING:
			if overshoot < 0.1:
				label.visible_ratio += delta
				if should_playsound():
					playsound()

				if Input.is_action_just_pressed("Enter") or label.visible_ratio >= 1:
					label.visible_ratio = 1.0
					end_symbol.text = "v"
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					text_change_state(text_State.FINISHED)
			else:
				overshoot *= 0.75
				var yP = get_viewport().size.y - textbox_container.get_rect().size.y - 30
				textbox_container.position.y += (yP - overshoot - textbox_container.position.y) / 5

		text_State.FINISHED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			if Input.is_action_just_pressed("Enter"):
				text_change_state(text_State.READY)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				hide_textbox()


func goose_talk():
	while(true):
		goose_handle_state()
		await requestManager.request_completed
		queue_text(requestManager.prev_response)
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
	text_change_state(text_State.READING)
	show_textbox()

func text_change_state(text_next_state):
	if text_next_state == text_State.FINISHED:
		input_txtBox.grab_focus()
	text_current_state = text_next_state

func goose_handle_state():
	match goose_current_state:
		goose_State.WELCOME:
			print("WELCOME")
			requestManager.welcome()
			goose_current_state = goose_State.QUESTION1

		goose_State.QUESTION1:
			print("Q1")
			print(inputted_text)
			requestManager.question1(inputted_text)
			await requestManager.request_completed
			prev_answer = requestManager.prev_answer
			input_txtBox.grab_focus()
			await sig_inputted_text

			if prev_answer != null:
				if inputted_text.to_lower() in prev_answer.to_lower():
					requestManager.correct()
				else:
					requestManager.incorrect()
				goose_current_state = goose_State.QUESTION2

		goose_State.QUESTION2:
			print("Q2")
			print(inputted_text)
			requestManager.question2(inputted_text)
			await requestManager.request_completed
			prev_answer = requestManager.prev_answer
			input_txtBox.grab_focus()
			await sig_inputted_text

			if prev_answer != null:
				if inputted_text.to_lower() in prev_answer.to_lower():
					requestManager.correct()
				else:
					requestManager.incorrect()
				goose_current_state = goose_State.QUESTION3

