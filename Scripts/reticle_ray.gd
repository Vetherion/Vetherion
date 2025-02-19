#TODO: Optimization

extends RayCast3D

@export var Reticle: CenterContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider and collider.is_in_group("Enemy"):
			Reticle.modulate = Color(255, 0, 255)
		else:
			Reticle.modulate = Color(255, 255, 255)
	else:
		Reticle.modulate = Color(255, 255, 255)
