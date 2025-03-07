extends RayCast3D

@onready var player1: CharacterBody3D = $"../../.."
@onready var weapon_ray: RayCast3D = $"."

const char_FREQ : float = 2.0
const char_AMP : float = 0.08
var t_char : float = 0.0

func _headchar(time : float) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * char_FREQ) * char_AMP
	pos.x = cos(time * char_FREQ / 2) * char_AMP
	return pos

func _process(delta: float) -> void:
	t_char += delta * player1.velocity.length() * float(player1.is_on_floor())
	weapon_ray.transform.origin = _headchar(t_char)
	
