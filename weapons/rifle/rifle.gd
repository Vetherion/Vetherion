extends WeaponClass

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var damagedistance : Curve 
@export var recoilcurve_y : Curve
@export var recoilcurve_x : Curve
@export var weapon_recoil_show : Curve

@onready var player : CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot : Node3D = get_parent().get_parent().get_parent()
@onready var level1 : Node3D = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var StateMachine = player.get_node("StateMachine")
@onready var weapon_ray = get_parent().get_parent().get_node("Weapon_Ray")
@onready var recoil : Node3D = get_parent().get_parent()
@onready var fire_particle: GPUParticles3D = $rifle0_mat/Node3D/GPUParticles3D

var ammocount : int = 0
var tempcount = 0
var rotation_tween: Tween = null
var core_spread : float = 0.01
var spread 

func _ready() -> void:
	animation_player.play("load_animation") 
	
func _physics_process(delta: float) -> void:
	#Handle Fire
	if (
		not (animation_player.current_animation in ["Reload", "load_animation"]) and
		Input.is_action_pressed("left_click") and 
		canshoot and 
		level1.magazine_rifle > 0 and 
		StateMachine.currentState == StateMachine.STATES.Move
):

		#fire_particle.position = rifle.position + Vector3(1.0 , 1.0, 1.0)
		fire_particle.emitting = true
		%particle.start()
		
		var increase = weapon_recoil_show.sample_baked(ammocount / 30.0) * 0.009
		var tween = get_tree().create_tween()
		var target_position = rifle.position + Vector3(0, increase, 1.5 * increase)
		tween.tween_property(rifle, "position", target_position, 0.05)
		
		level1.magazine_rifle -= 1
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = str(level1.magazine_rifle)
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo_total").text = str(level1.ammo_rifle)
		AmmoVariables.rifle_ammo = level1.magazine_rifle
		canshoot = false
		%rifle_fire_rate.start()
		ammocount += 1
		if ammocount < 5:
			AmmocountVariable.ammocount = ammocount
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
			weapon_ray.rotation_degrees = Vector3(90, 0, 0)
		
		camerapivot.rotation.x += (recoilcurve_y.sample_baked(ammocount/30.0))/75
		camerapivot.rotation.y += (recoilcurve_x.sample_baked(ammocount/30.0))/75
		
		var spread = clamp((core_spread * (ammocount + 29) * ((player.velocity.x + 4.0) * 0.25) * ((player.velocity.y + 4.0) * 0.25) * ((player.velocity.z + 4.0) * 0.25)) / 150.0, 0.0, 0.03)
		weapon_ray.rotation.x += randf_range(-spread , spread * 2)
		if camerapivot.rotation.y < 0:
			weapon_ray.rotation.y -= randf_range(-spread, spread * 2)
		if camerapivot.rotation.y > 0:
			weapon_ray.rotation.y -= randf_range(spread, -spread * 2)
		#weapon_ray.rotation(core bir spread seması olacak ve her vurus sonrası ray sıfırlanıp tekrar spread eklenecek)
		
func _on_rifle_fire_rate_timeout() -> void:
	canshoot = true
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Reload"):
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = "Reloading"
		animation_player.play("Reload")
		if level1.ammo_rifle >= level1.max_magazine_rifle:
			level1.ammo_rifle = level1.ammo_rifle - level1.max_magazine_rifle + level1.magazine_rifle
			level1.magazine_rifle = level1.max_magazine_rifle
		elif level1.ammo_rifle > 0:
			level1.magazine_rifle += level1.ammo_rifle
			level1.ammo_rifle = 0
			if level1.magazine_rifle > level1.max_magazine_rifle:
				level1.ammo_rifle = level1.magazine_rifle - level1.max_magazine_rifle
				level1.magazine_rifle = level1.max_magazine_rifle
				
		#get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = str(level1.magazine_rifle)
		#get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo_total").text = str(level1.ammo_rifle)
		AmmoVariables.rifle_ammo = level1.magazine_rifle
		AmmoVariables.rifle_total_ammo = level1.ammo_rifle
		
	if event is InputEventMouseMotion and rotation_tween:
		rotation_tween.kill()  
		rotation_tween = null
		var target_rotation_x = camerapivot.rotation.x - (0.005 * tempcount + 0.005)
		camerapivot.rotation.x = lerp(camerapivot.rotation.x, target_rotation_x, 0.1)
		
func _on_recoil_reset_timeout() -> void:
	rifle.position = Vector3(0.5, -0.3, -0.5)
	tempcount = ammocount
	ammocount = 0
	AmmocountVariable.ammocount = ammocount
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(camerapivot, "rotation:x", camerapivot.rotation.x - deg_to_rad(tempcount * 0.45), 0.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

func _process(delta):
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0 and rotation_tween:
		rotation_tween.kill()
		rotation_tween = null

func _on_particle_timeout() -> void:
	fire_particle.emitting = false
