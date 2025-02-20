extends WeaponClass

@export var damagedistance : Curve  

@onready var camera3d : Camera3D = get_parent()
@onready var player : CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot : Node3D = get_parent().get_parent().get_parent()
@onready var level1 : Node3D = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var StateMachine = player.get_node("StateMachine") 
@onready var weapon_ray = get_parent().get_parent().get_node("Weapon_Ray")
@onready var recoil : Node3D = get_parent().get_parent()

func _input(event: InputEvent) -> void:
	#Handle Fire
	if  Input.is_action_just_pressed("left_click") and canshoot and level1.magazine_sniper > 0 and StateMachine.currentState == StateMachine.STATES.Move:
		level1.magazine_sniper -= 1
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo").text = str(level1.magazine_sniper)
		get_node("../../../../HUD/Cnt/Panel/Cnt/Ammo_total").text = str(level1.ammo_sniper)
		AmmoVariables.sniper_ammo = level1.magazine_sniper
		#Timer
		canshoot = false
		%sniper_fire_rate.start()
		
		if weapon_ray.is_colliding():
			var collider = weapon_ray.get_collider()
			if collider and collider.is_in_group("Enemy"):
				distance = abs(player.global_position.distance_to(collider.global_position)) * 0.01
				collider.damage(round(100.0 * damagedistance.sample_baked(distance)))
			
		camerapivot.rotation.x += 0.05
		#weapon_ray.rotation.x += 0.05
		
	if Input.is_action_just_pressed("Reload"):
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
func _on_sniper_fire_rate_timeout() -> void:
	canshoot = true
