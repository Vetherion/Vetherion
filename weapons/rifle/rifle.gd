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
var ammocount : int
var temp_rotation

func _physics_process(delta: float) -> void:
	#Handle Fire
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0 and StateMachine.currentState == StateMachine.STATES.Move:
		#Timer
		level1.magazine_rifle -= 1
		canshoot = false
		%rifle_fire_rate.start()
		ammocount += 1
		%recoil_reset.start()
		
		if weapon_ray.is_colliding():
			var collider = weapon_ray.get_collider()
			if collider and collider.is_in_group("Enemy"):
				distance = abs(player.global_position.distance_to(collider.global_position)) * 0.01
				collider.damage(round(20.0 * (damagedistance.sample_baked(distance))))
		
		if ammocount == 1:
			temp_rotation = camerapivot.rotation.x
		
		camerapivot.rotation.x += 0.02
		
	
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


var rotation_tween: Tween = null

func _on_recoil_reset_timeout() -> void:
	ammocount = 0
	# Tween'i oluşturup, döndürme animasyonunu başlatıyoruz.
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(camerapivot, "rotation:x", temp_rotation, 0.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

func _process(delta):
	# Belirli bir input geldiğinde (örneğin "cancel_rotation" adlı input action)
	if  Input.is_action_pressed("left_click") and canshoot and level1.magazine_rifle > 0 and rotation_tween:
		rotation_tween.kill()  # Tween'i iptal ediyoruz.
		rotation_tween = null
