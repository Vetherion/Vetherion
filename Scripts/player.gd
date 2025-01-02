extends CharacterBody3D
var RAY_LENGTH = 100.0

#weapons
@onready var rifle: Node3D = $CameraPivot/Recoil/Camera3D/Rifle
@onready var sniper: Node3D = $CameraPivot/Recoil/Camera3D/Sniper
var damage : float = 20.0
@onready var firerate: Timer = %Firerate

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.1

@export_group("Movement")
@export var move_speed := 5.0
@export var acceleration := 20.0
@export var JUMP_VELOCITY = 15.0
var camera_input_direction := Vector2.ZERO

@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D

@onready var ray_cast_3d: RayCast3D = $CameraPivot/Recoil/Camera3D/RayCast3D
@onready var in_col = 0 
var canshoot = true

#stamina variables
var SPRINT_SPEED = 8.0
var WALK_SPEED = 5.0
var stamina = 100

#head movement variables
const char_FREQ = 2.0
const char_AMP = 0.08
var t_char = 0.0

@onready var inventory_script = get_node("Inventory")

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
	
	# Weapon select DEGISECEK
	if Input.is_action_just_pressed("Rifle"):
		rifle.visible = true
		sniper.visible = false
		damage = 20.0
		firerate.wait_time = 0.12
		RAY_LENGTH = 100.0
	if Input.is_action_just_pressed("Sniper"):
		rifle.visible = false
		sniper.visible = true
		damage = 100.0
		firerate.wait_time = 1.25
		RAY_LENGTH = 1000.0
	if Input.is_action_just_pressed("Punch"):
		rifle.visible = false
		sniper.visible = false
		damage = 10.0
		firerate.wait_time = 0.5
		RAY_LENGTH = 2.0
	
func _unhandled_input(event: InputEvent) -> void:
	# Set camera_input_direction
	var is_camera_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity
		
func _physics_process(delta: float) -> void:
		#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot:
		#Timer
		canshoot = false
		%Firerate.start()
		#Raycast
		var mousePos = get_viewport().get_size()/2
		var camera3d = %Camera3D
		var from = camera3d.project_ray_origin(mousePos)
		var to = from + camera3d.project_ray_normal(mousePos) * RAY_LENGTH
		
		var new_intersection = PhysicsRayQueryParameters3D.create(from, to)
		var intersection = camera3d.get_world_3d().direct_space_state.intersect_ray(new_intersection)
		
		if intersection and intersection.collider.is_in_group("Enemy"):
			intersection.collider.damage(damage)
	
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
	if %Dialogue.visible == false:
		var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var forward := camera_3d.global_basis.z
		var right := camera_3d.global_basis.x
		
		var move_direction := forward * raw_input.y + right * raw_input.x
		move_direction.y = 0.0
		move_direction = move_direction.normalized()
		
		velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)

	  
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	## inventory
	if inventory_script.is_eligible() != null:
		%Label.visible = 1
		if Input.is_action_just_pressed("E"):
			var item = inventory_script.is_eligible()
			if "gun0" in item.get_groups():
				inventory_script.add_to_inv("gun0")
			item.queue_free()
		else:
			pass
	else:
		%Label.visible = 0
		
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


func _on_firerate_timeout() -> void:
	canshoot = true
