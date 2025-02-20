extends Node
class_name WeaponClass

@onready var rifle: Node3D = $"."
@onready var sniper: Node3D = $"."

var canshoot : bool = true
var current_weapon: Node3D = null

var distance : float

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Rifle"):
		var rifle_scene : PackedScene = preload("res://weapons/rifle/Rifle.tscn")
		spawn_weapon(rifle_scene)
		get_node("../../../HUD/Panel/Gun").text = "rifle0"
		get_node("../../../HUD/Panel/Cnt/Ammo").text = str(AmmoVariables.rifle_ammo)
		get_node("../../../HUD/Panel/Cnt/Ammo_total").text = str(AmmoVariables.rifle_total_ammo)
	if Input.is_action_just_pressed("Sniper"):
		var sniper_scene : PackedScene = preload("res://weapons/sniper/sniper.tscn")
		spawn_weapon(sniper_scene)
		get_node("../../../HUD/Panel/Gun").text = "sniper0"
		get_node("../../../HUD/Panel/Cnt/Ammo").text = str(AmmoVariables.sniper_ammo)
		get_node("../../../HUD/Panel/Cnt/Ammo_total").text = str(AmmoVariables.sniper_total_ammo)
		
func spawn_weapon(weapon_scene: PackedScene) -> void:
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon_scene.instantiate()
	add_child(current_weapon)
	current_weapon.position = Vector3(0.5, -0.3, -0.5) 
