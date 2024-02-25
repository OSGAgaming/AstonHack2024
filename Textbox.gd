extends CanvasLayer

const CHAR_READ_RATE = 0.05
const TIME_BETWEEN_QUESTIONS = 5
var Time_left_between_questions = 0

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/End
@onready var label = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var requestManager = $HTTPRequest
@onready var input_txtBox = $TextboxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/Panel/InputContainer/LineEdit
@onready var portrait = $TextboxContainer/HBoxContainer/Panel2/Sprite2D
@onready var audience = get_tree().get_root().get_node("Node3D/Audience")
@onready var applause = preload("res://assets/applause.wav")

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
	QUESTION,
	NONSENSICAL,
	FREEREIGN
}

var curr_questions = 1
var max_questions = 3
var curr_nonsensical = 1
var max_nonsensical = 2
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
		$GooseAudio.stream = honks.pick_random()
		$GooseAudio.play()

func play_applause():
		audience.stream = applause
		audience.play()

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
			input_txtBox.release_focus()
			if Time_left_between_questions > 0:
				Time_left_between_questions -= delta
			if !text_queue.is_empty() && Global.gameState == Global.GameState.Gameplay and Time_left_between_questions <= 0:
				overshoot = 50
				display_text()
			textbox_container.position.y += (1000 - textbox_container.position.y) / 5
		text_State.READING:
			if overshoot < 0.1:
				Global.focused = true
				label.visible_ratio += delta
				portrait.get_child(0).play("yap")
				if should_playsound():
					playsound()

				if Input.is_action_just_pressed("Enter") or label.visible_ratio >= 1:
					label.visible_ratio = 1.0
					end_symbol.text = "v"
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					text_change_state(text_State.FINISHED)
					portrait.get_child(0).play("idle")
			else:
				overshoot *= 0.75
				var yP = get_viewport().size.y - textbox_container.get_rect().size.y - 30
				textbox_container.position.y += (yP - overshoot - textbox_container.position.y) / 5

		text_State.FINISHED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			if Input.is_action_just_pressed("Enter"):
				Global.focused = false
				text_change_state(text_State.READY)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				Time_left_between_questions = TIME_BETWEEN_QUESTIONS
				hide_textbox()

func goose_talk():
	while(true):
		goose_handle_state()
		await requestManager.request_completed
		queue_text(requestManager.prev_response)
		await sig_inputted_text

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	#textbox_container.hide()

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
		await get_tree().process_frame
		input_txtBox.grab_focus()

	text_current_state = text_next_state

func goose_handle_state():
	match goose_current_state:
		goose_State.WELCOME:
			requestManager.welcome()
			goose_current_state = goose_State.QUESTION

		goose_State.QUESTION:
			curr_questions += 1
			requestManager.question()
			await requestManager.request_completed
			prev_answer = requestManager.prev_answer
			await sig_inputted_text

			if prev_answer != null:
				if inputted_text.to_lower() in prev_answer.to_lower():
					requestManager.correct()
					play_applause()
				else:
					requestManager.incorrect()
				if curr_questions > max_questions:
					goose_current_state = goose_State.NONSENSICAL
		
		goose_State.NONSENSICAL:
			curr_nonsensical += 1
			requestManager.nonsensical(inputted_text)
			await requestManager.request_completed
			prev_answer = requestManager.prev_answer
			await sig_inputted_text

			if prev_answer != null:
				if inputted_text.to_lower() in prev_answer.to_lower():
					requestManager.correct()
					play_applause()
				else:
					requestManager.incorrect()
				if curr_nonsensical > max_nonsensical:
					goose_current_state = goose_State.FREEREIGN
					
		goose_State.FREEREIGN:
			requestManager.freereign(inputted_text)
			await requestManager.request_completed
			prev_answer = requestManager.prev_answer
			await sig_inputted_text

			if prev_answer != null:
				if inputted_text.to_lower() in prev_answer.to_lower():
					requestManager.correct()
					play_applause()
				else:
					requestManager.incorrect()
