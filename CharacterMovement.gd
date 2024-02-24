extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var eyes := $Eyes
@onready var camera := $Eyes/View
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if Global.isGameMenu: 
		return;
	if event is InputEventMouseMotion:
		eyes.rotate_y(-0.01 * event.relative.x)
		camera.rotate_x(-0.01 * event.relative.y)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))

func _physics_process(delta):
	if Global.isGameMenu: 
		return;
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Space") and is_on_floor() and not Global.focused:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (eyes.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and not Global.focused:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _ready():
	eyes.rotate_y(180)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
