extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.1

@export_group("Movement")
@export var move_speed := 5.0
@export var acceleration := 20.0
@export var JUMP_VELOCITY = 15.0
var camera_input_direction := Vector2.ZERO

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D

#stamina variables
var SPRINT_SPEED = 8.0
var WALK_SPEED = 5.0
var stamina = 100
#head movement variables
const char_FREQ = 2.0
const char_AMP = 0.08
var t_char = 0.0

func _ready() -> void: #Start the game by capturing the mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #now you can use your mouse 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE #now you cant use your mouse

func _unhandled_input(event: InputEvent) -> void:
	# Set camera_input_direction
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity
		
func _physics_process(delta: float) -> void:
	# Handle sprint 
	if Input.is_action_pressed("sprint") and stamina >= 75:
		move_speed = SPRINT_SPEED
		stamina -= 10.0 * delta
	else:
		move_speed = WALK_SPEED
		stamina += 2.0 * delta
		stamina = clamp(stamina, 0, 100)
	# Set camera angle by using camera_input_direction
	camera_pivot.rotation.x -= camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 3.0, PI / 1.5) #Limit for Vision Rotate
	camera_pivot.rotation.y -= camera_input_direction.x * delta 
	
	camera_input_direction = Vector2.ZERO 
	
	if Input.is_action_just_pressed("left_click"):
		pass
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handle movement
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := camera_3d.global_basis.z
	var right := camera_3d.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	  
func _process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
	# Head char 
	t_char += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _headchar(t_char)

	move_and_slide()
func _headchar(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * char_FREQ) * char_AMP
	pos.x = cos(time * char_FREQ / 2) * char_AMP
	return pos
