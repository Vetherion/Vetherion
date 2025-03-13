extends HBoxContainer

var selected_item: String
@export var player: Node3D
@onready var camera = %Camera3D
var level: Node3D
@export var sniper0_scene: PackedScene
const A = 30

func _ready() -> void:
	level = player.get_parent()

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
	var item = sniper0_scene.instantiate()
	level.add_child(item)
	#item.position = Vector3(0.5,0.5,0.5)
	#print(player.get_node("CameraPivot").rotation)
	#item.position = Vector3(player.position.x + 2, player.position.y, player.position.z)
	item.position = Vector3(player.position.x + 0.05*A, player.position.y, player.position.z + sqrt(2*(A^2) - 2*(A^2)*cos(player.get_node("CameraPivot").rotation.y)))
