extends CharacterBody3D

@export var player: CharacterBody3D
@export var camera_pivot: Node3D 
@export var camera3d: Camera3D 

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity : float = 0.1

@export_group("Movement")
@export var move_speed : float = 5.0
@export var acceleration : float = 20.0
@export var JUMP_VELOCITY : float = 15.0
var camera_input_direction : Vector2 = Vector2.ZERO

#stamina variables
var SPRINT_SPEED : float = 8.0
var WALK_SPEED : float = 5.0
var stamina : float = 100

#head movement variables
const char_FREQ : float = 2.0
const char_AMP : float = 0.08
var t_char : float = 0.0

func _ready() -> void: #Start the game by capturing the mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
func _input(event: InputEvent) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#MOUSE MODE
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #now you can use your mouse 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE #now you cant use your mouse

func _unhandled_input(event: InputEvent) -> void:
	# Set camera_input_direction
	var is_camera_motion : bool = (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
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
	
	# Handle movement
	var raw_input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward : Vector3 = camera3d.global_basis.z
	var right : Vector3 = camera3d.global_basis.x
	
	var move_direction : Vector3 = forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	
func _process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
	# Head char 
	t_char += delta * velocity.length() * float(is_on_floor())
	camera3d.transform.origin = _headchar(t_char)
	
	move_and_slide()
	
func _headchar(time : float) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * char_FREQ) * char_AMP
	pos.x = cos(time * char_FREQ / 2) * char_AMP
	return pos
