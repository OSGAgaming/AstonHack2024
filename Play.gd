extends Button

@onready var playCouroutineReady = false;
@onready var playCouroutine = 0;
@onready var centerStage = get_node("/root/Node3D/CenterStage")
@onready var player = get_tree().get_root().get_node("Node3D/player");
@onready var eyes = get_tree().get_root().get_node("Node3D/player/Eyes");
@onready var goose = get_tree().get_root().get_node("Node3D/Goose");

var music = preload("res://assets/gameshow.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music():
	if !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.stream = music
		$AudioStreamPlayer2D.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playCouroutineReady:
		playCouroutine += delta
		if playCouroutine < 3:
			Global.transitionAlpha = playCouroutine / 3
			player.position.z += delta
			player.rotation.y -= 0.1 * delta
		else:
			play_music()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Global.transitionAlpha = (3 -(playCouroutine - 3)) / 3
			player.position.x = centerStage.position.x;
			player.position.z = centerStage.position.z;
			eyes.look_at(goose.position)
			if playCouroutine >= 6:
				Global.gameState = Global.GameState.Gameplay;
				playCouroutineReady = false

	pass


func _on_pressed():
	playCouroutineReady = true
	Global.gameState = Global.GameState.GameplayReady;


