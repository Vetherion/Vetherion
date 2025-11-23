extends VehicleBody3D

const MAX_STEER : float = 0.5
const ENGINE_POWER : int = 200
const BACKWARD_OFFSET_DISTANCE : float = 105.0 
const CAMERA_TRACKING_SPEED : float = 30.0 

var camera_input_direction : Vector2 = Vector2.ZERO
@export var camera_pivot: Node3D
@export var camera_3d: Camera3D
var look_at : Vector3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

func _physics_process(delta: float) -> void:
	if camera_3d.current:
		steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 2.5)
		engine_force = Input.get_axis("move_back", "move_forward") * ENGINE_POWER
		
		var forward_vector: Vector3 =  global_transform.basis.z
		var forward_speed: float = linear_velocity.dot(forward_vector)
		var offset_vector: Vector3 = Vector3.ZERO
		
		if forward_speed < -0.1:
			offset_vector = forward_vector * BACKWARD_OFFSET_DISTANCE

		var target_position: Vector3 = global_position + offset_vector

		# Pozisyon takibini hızlandır
		camera_pivot.global_position = camera_pivot.global_position.lerp(target_position, delta * CAMERA_TRACKING_SPEED)
		
		# Rotasyon takibini çok daha hızlı yap
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 50.0) 
		
		# LOOK_AT NOKTASINI SADECE GLOBAL POZİSYONA KİLİTLE
		look_at = look_at.lerp(global_position, delta * 10)
		camera_3d.look_at(look_at)
	else:
		steering = move_toward(0, 0, 0)
		engine_force = 0
		
	camera_input_direction = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion : bool = (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * 0.2
