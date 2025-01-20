extends WeaponClass

@export var damagedistance : Curve 

func _physics_process(delta: float) -> void:
			#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot:
		#Timer
		canshoot = false
		%rifle_fire_rate.start()
		#Raycast
		var mousePos : Vector2 = get_viewport().get_size()/2
		var from : Vector3 = get_parent().project_ray_origin(mousePos)
		var to : Vector3 = from + get_parent().project_ray_normal(mousePos) * 200.0
		
		var new_intersection : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		var intersection : Dictionary = get_parent().get_world_3d().direct_space_state.intersect_ray(new_intersection)

		if intersection and intersection.collider.is_in_group("Enemy"):
			distance = abs(get_parent().get_parent().get_parent().get_parent().global_position.distance_to(intersection.collider.global_position)) * 0.01
			intersection.collider.damage(20.0 * round(damagedistance.sample_baked(distance)))
		
		get_parent().get_parent().get_parent().rotation.x += 0.05

func _on_rifle_fire_rate_timeout() -> void:
	canshoot = true
