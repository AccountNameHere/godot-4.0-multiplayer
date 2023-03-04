extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.1
@onready var syncro = $Node/MultiplayerSynchronizer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Back in network.gd we named the root of this scene to the ID of the owner, now we can use that to set
	# the multiplayer_authority here
	syncro.set_multiplayer_authority(name.to_int())
	$PlayerTag.text = name
	if syncro.is_multiplayer_authority():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$CameraPivot/SpringArm3D/Camera3D.current = true

func _input(event):
	if not syncro.is_multiplayer_authority(): return
	# A basic 3rd person camera controller
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		$CameraPivot.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	if syncro.is_multiplayer_authority():
		# Just the Godot CharacterBody3D template with WASD instead of arrows
		if not is_on_floor():
			velocity.y -= gravity * delta

		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	# We give the MultiplayerSynchronizer our new position so it can sync it with the others
	$Node.pos = position

# When we recieve an update position form the MultiplayerSynchronizer, we move the CharacterBody3D there
func _on_multiplayer_synchronizer_synchronized():
	position = $Node.pos
