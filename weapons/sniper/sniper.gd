extends WeaponClass

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var damagedistance : Curve  

@onready var camera : Camera3D = get_parent()
@onready var player : CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot : Node3D = get_parent().get_parent().get_parent()
@onready var level1 : Node3D = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var StateMachine = player.get_node("StateMachine") 
@onready var weapon_ray = get_parent().get_parent().get_node("Weapon_Ray")
@onready var recoil : Node3D = get_parent().get_parent()

func _ready() -> void:
	animation_player.play("load_animation") 
	
func _input(event: InputEvent) -> void:
	#Handle Fire
	if  not (animation_player.current_animation in ["Reload", "load_animation"]) and Input.is_action_just_pressed("left_click") and canshoot and level1.magazine_sniper > 0 and StateMachine.currentState == StateMachine.STATES.Move:
		level1.magazine_sniper -= 1
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = str(level1.magazine_sniper)
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo_total").text = str(level1.ammo_sniper)
		AmmoVariables.sniper_ammo = level1.magazine_sniper
		#Timer
		canshoot = false
		%sniper_fire_rate.start()
		
		var spread_y = (((player.velocity.x + 4.0) * 0.25) * ((player.velocity.y + 4.0) * 0.25) * ((player.velocity.z + 4.0) * 0.25))
		var spread_x = (((player.velocity.x + 4.0) * 0.25) * ((player.velocity.y + 4.0) * 0.25) * ((player.velocity.z + 4.0) * 0.25))
		spread_y = randf_range(spread_y * 0.9, spread_y * 1.1)
		spread_x = randf_range(spread_x * 0.9, spread_x * 1.1)
		weapon_ray.rotation_degrees = Vector3(90 + spread_y, -spread_x, 0) 
		
		if weapon_ray.is_colliding():
			var collider = weapon_ray.get_collider()
			if collider and collider.is_in_group("Enemy"):
				distance = abs(player.global_position.distance_to(collider.global_position)) * 0.01
				collider.damage(round(200.0 * damagedistance.sample_baked(distance)))
			
			var collision_point = weapon_ray.get_collision_point()
			var new_scene = preload("res://weapons/bullet_trace.tscn").instantiate()
			collider.add_child(new_scene)
			new_scene.global_transform.origin = collision_point
			
		camerapivot.rotation.x += 0.05
		var tween = get_tree().create_tween()
		tween = get_tree().create_tween()
		tween.tween_property(camerapivot, "rotation:x", camerapivot.rotation.x - 0.05, 0.5)

	if Input.is_action_just_pressed("Reload"):
		animation_player.play("Reload")
		if level1.ammo_sniper >= level1.max_magazine_sniper:
			level1.ammo_sniper = level1.ammo_sniper - level1.max_magazine_sniper + level1.magazine_sniper
			level1.magazine_sniper = level1.max_magazine_sniper
		elif level1.ammo_sniper > 0:
			level1.magazine_sniper += level1.ammo_sniper
			level1.ammo_sniper = 0
			if level1.magazine_sniper > level1.max_magazine_sniper:
				level1.ammo_sniper = level1.magazine_sniper - level1.max_magazine_sniper
				level1.magazine_sniper = level1.max_magazine_sniper
		AmmoVariables.sniper_ammo = level1.magazine_sniper
		AmmoVariables.sniper_total_ammo = level1.ammo_sniper
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = str(level1.magazine_sniper)
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo_total").text = str(level1.ammo_sniper)
		
func _process(delta: float)-> void:
	if Input.is_action_just_pressed("Right_Click"):
		camera.fov = 10
		sniper.find_child("sniper_2").visible = false
		camera.find_child("scope").visible = true
		player.find_child("UserInterface").find_child("ReticleSniper").visible = true
	if Input.is_action_just_released("Right_Click"):
		sniper.find_child("sniper_2").visible = true
		camera.fov = 75
		camera.find_child("scope").visible = false
		player.find_child("UserInterface").find_child("ReticleSniper").visible = false
		
func _on_sniper_fire_rate_timeout() -> void:
	canshoot = true
