extends VehicleBody3D

const MAX_STEER : float = 0.5
const ENGINE_POWER : int = 200

var camera_input_direction : Vector2 = Vector2.ZERO

@export var camera_pivot: Node3D
@export var camera_3d: Camera3D

var look_at : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

func _physics_process(delta: float) -> void:
	if camera_3d.current:
		steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta * 2.5)
		engine_force = Input.get_axis("move_back", "move_forward") * ENGINE_POWER
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		look_at = look_at.lerp(global_position + linear_velocity, delta * 5)
		camera_3d.look_at(look_at)
		#camera_pivot.rotation.x -= camera_input_direction.y * delta
		#camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 6.0, PI / 9) #Limit for Vision Rotate
		#camera_pivot.rotation.y -= camera_input_direction.x * delta 
		
	camera_input_direction = Vector2.ZERO 
func _unhandled_input(event: InputEvent) -> void:
	# Set camera_input_direction
	var is_camera_motion : bool = (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * 0.2
