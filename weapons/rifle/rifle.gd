extends WeaponClass

@export var damagedistance : Curve 
@export var recoilcurve_y : Curve
@export var recoilcurve_x : Curve

@onready var camera3d : Camera3D = get_parent()
@onready var player : CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot : Node3D = get_parent().get_parent().get_parent()
@onready var level1 : Node3D = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var StateMachine = player.get_node("StateMachine")
@onready var weapon_ray = get_parent().get_parent().get_node("Weapon_Ray")
@onready var recoil : Node3D = get_parent().get_parent()

var ammocount : int = 0
var temp_rotation
var tempcount = 0
var rotation_tween: Tween = null
var core_spread : float = 0.01
var spread 

func _physics_process(delta: float) -> void:
	#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0 and StateMachine.currentState == StateMachine.STATES.Move:
		#Timer
		level1.magazine_rifle -= 1
		get_node("../../../../HUD/Panel/Ammo").text = str(level1.magazine_rifle) + "/" + str(level1.ammo_rifle)
		AmmoVariables.rifle_ammo = level1.magazine_rifle
		canshoot = false
		%rifle_fire_rate.start()
		ammocount += 1
		%recoil_reset.start()
		
		if weapon_ray.is_colliding():
			var collider = weapon_ray.get_collider()
			if collider and collider.is_in_group("Enemy"):
				distance = abs(player.global_position.distance_to(collider.global_position)) * 0.01
				collider.damage(round(20.0 * (damagedistance.sample_baked(distance))))
				
			var collision_point = weapon_ray.get_collision_point()
			var new_scene = preload("res://weapons/bullet_trace.tscn").instantiate()
			collider.add_child(new_scene)
			new_scene.global_transform.origin = collision_point
			
		if ammocount == 1:
			temp_rotation = camerapivot.rotation.x
			weapon_ray.rotation_degrees = Vector3(90, 0, 0)
		
		camerapivot.rotation.x += (recoilcurve_y.sample_baked(ammocount/30.0))/100.0
		camerapivot.rotation.y += (recoilcurve_x.sample_baked(ammocount/30.0))/100.0
		
		
		var spread = clamp((core_spread * (ammocount + 29) * (player.velocity.x + 1.0) * (player.velocity.y + 1.0) * (player.velocity.z + 1.0)) / 150.0, 0.0, 0.03)
		weapon_ray.rotation.x += randf_range(-spread, spread * 2)
		weapon_ray.rotation.y -= randf_range(-spread, spread * 2)
		
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
		get_node("../../../../HUD/Panel/Ammo").text = str(level1.magazine_rifle) + "/" + str(level1.ammo_rifle)
		AmmoVariables.rifle_ammo = level1.magazine_rifle
		AmmoVariables.rifle_total_ammo = level1.ammo_rifle

func _on_recoil_reset_timeout() -> void:
	tempcount = ammocount
	ammocount = 0
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(camerapivot, "rotation:x", camerapivot.rotation.x - deg_to_rad(tempcount * 0.3), 0.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

func _process(delta):
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0 and rotation_tween:
		rotation_tween.kill()
		rotation_tween = null
