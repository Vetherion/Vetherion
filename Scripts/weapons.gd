extends Node
class_name WeaponClass

@onready var rifle: Node3D = $"."
@onready var sniper: Node3D = $"."

var canshoot 
var current_weapon: Node3D = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Punch"):
		if current_weapon:
			current_weapon.queue_free()
		current_weapon = null
	if Input.is_action_just_pressed("Rifle"):
		var rifle_scene = preload("res://Scenes/Rifle.tscn")
		spawn_weapon(rifle_scene)
	if Input.is_action_just_pressed("Sniper"):
		var sniper_scene = preload("res://Scenes/sniper.tscn")
		spawn_weapon(sniper_scene)
		
func spawn_weapon(weapon_scene: PackedScene) -> void:
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon_scene.instantiate()
	add_child(current_weapon)
	current_weapon.position = Vector3(0.5, -0.3, -0.5) 
