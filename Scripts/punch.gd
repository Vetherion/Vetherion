extends WeaponClass

func _physics_process(delta: float) -> void:
			#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot:
		#Timer
		canshoot = false
		%punch_fire_rate.start()
		#Raycast
		var mousePos : Vector2 = get_viewport().get_size()/2
		var from : Vector3 = get_parent().project_ray_origin(mousePos)
		var to : Vector3 = from + get_parent().project_ray_normal(mousePos) * 1.5
		
		var new_intersection : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		var intersection : Dictionary = get_parent().get_world_3d().direct_space_state.intersect_ray(new_intersection)

		if intersection and intersection.collider.is_in_group("Enemy"):
			intersection.collider.damage(50.0)


func _on_punch_fire_rate_timeout() -> void:
	canshoot = true
