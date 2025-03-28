extends CharacterBody3D

@export var speed: float = 8.0
@export var sprint_speed: float = 15.0
@export var crouch_speed: float = 5.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var crouch_height: float = 1.0
@export var normal_height: float = 2.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var camera_x_rotation: float = 0.0
var is_crouching: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func teleport_to(new_position: Vector3):
	global_transform.origin = new_position
	velocity = Vector3.ZERO

func _physics_process(delta):
	var movement_vector = Vector3.ZERO
	var current_speed = speed

	# Shift
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	# Ctrl
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		current_speed = crouch_speed
	else:
		is_crouching = false

	var target_height = crouch_height if is_crouching else normal_height
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, delta * 10)

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
