extends CharacterBody3D

@export var move_speed := 5.0
@export var mouse_sensitivity := 0.006
@export var jump_velocity := 5.0
@export var gravity := 9.8

@export var camera : Camera3D
var y_rotation := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Horizontal rotation
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical look (pitch)
		y_rotation = clamp(y_rotation - event.relative.y * mouse_sensitivity, deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.x = y_rotation

func _physics_process(delta):
	var direction := Vector3.ZERO

	if Input.is_action_pressed("MoveForward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("MoveBackward"):
		direction += transform.basis.z
	if Input.is_action_pressed("MoveLeft"):
		direction -= transform.basis.x
	if Input.is_action_pressed("MoveRight"):
		direction += transform.basis.x

	direction = direction.normalized()
	
	# Apply gravity
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Allow jumping
		if Input.is_action_just_pressed("Jump"):
			velocity.y = jump_velocity
		else:
			velocity.y = 0

	# Move in desired direction
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	move_and_slide()
