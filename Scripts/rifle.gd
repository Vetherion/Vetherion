extends WeaponClass

@export var damagedistance : Curve 

@onready var camera3d : Camera3D = get_parent()
@onready var player : CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot : Node3D = get_parent().get_parent().get_parent()
@onready var level1 : Node3D = get_parent().get_parent().get_parent().get_parent().get_parent()

func _physics_process(delta: float) -> void:
	#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0:
		#Timer
		level1.magazine_rifle -= 1
		canshoot = false
		%rifle_fire_rate.start()
		#Raycast
		var mousePos : Vector2 = get_viewport().get_size()/2
		var from : Vector3 = camera3d.project_ray_origin(mousePos)
		var to : Vector3 = from + camera3d.project_ray_normal(mousePos) * 200.0
		
		var new_intersection : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		var intersection : Dictionary = camera3d.get_world_3d().direct_space_state.intersect_ray(new_intersection)

		if intersection and intersection.collider.is_in_group("Enemy"):
			distance = abs(player.global_position.distance_to(intersection.collider.global_position)) * 0.01
			intersection.collider.damage(20.0 * round(damagedistance.sample_baked(distance)))
		
		camerapivot.rotation.x += 0.05

func _on_rifle_fire_rate_timeout() -> void:
	canshoot = true
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Reload"):
		if level1.ammo_rifle >= level1.max_magazine_rifle:
			level1.ammo_rifle = level1.ammo_rifle - level1.max_magazine_rifle + level1.magazine_rifle
			level1.magazine_rifle = level1.max_magazine_rifle
		elif level1.ammo_rifle > 0:
			level1.magazine_rifle += level1.ammo_rifle
			level1.ammo_rifle = 0
			if level1.magazine_rifle > level1.max_magazine_rifle:
				level1.ammo_rifle = level1.magazine_rifle - level1.max_magazine_rifle
				level1.magazine_rifle = level1.max_magazine_rifle
