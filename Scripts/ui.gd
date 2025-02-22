extends HBoxContainer

var selected_item: String
@export var player: Node3D
@onready var camera = %Camera3D

# Equip button
func _on_equip_pressed() -> void:
	if selected_item == "inv_rifle0":
		camera.spawn_weapon(preload("res://weapons/rifle/Rifle.tscn"))
	elif selected_item == "inv_sniper0":
		camera.spawn_weapon(preload("res://weapons/sniper/sniper.tscn"))

# Inequip button
func _on_inequip_pressed() -> void:
	if camera.current_weapon != null:
		camera.current_weapon.queue_free()
		camera.current_weapon = null

# Drop button
func _on_drop_pressed() -> void:
	#TODO: Make a drop function
	pass
