extends Node

@export var inventory: Node
@export var player: CharacterBody3D
@export var SaveResource: Resource

const SAVE_PATH = "res://save_resource2.tres"

	
func SaveGame() -> void:
	SaveResource.health = player.health
	SaveResource.rifle0_bullet_has = 0; SaveResource.rifle0_bullet_loaded = 0; SaveResource.sniper0_bullet_loaded = 0;SaveResource.sniper0_bullet_has = 0;
	SaveResource.inventory = inventory.inventory
	SaveResource.inventory_gui = inventory.inventory_gui
	SaveResource.position = player.position
	ResourceSaver.save(SaveResource, SAVE_PATH)

func LoadGame() -> Resource:
	if ResourceLoader.exists(SAVE_PATH):
		return load(SAVE_PATH)
	else:
		return null
	

func _on_save_pressed() -> void:
	SaveGame() 


func _on_load_pressed() -> void:
	var save = LoadGame() 
	if save:
		player.position = save.position
		player.health = save.health
		inventory.inventory = save.inventory
		inventory.inventory_gui = save.inventory_gui
		inventory.load_gui()
		$"../HUD/load2".text = "Loaded: " + "pos: " + str(player.position) + "\nhp: " + str(player.health) + "\ninv: " + str(inventory.inventory) + "\ninv_gui: " + str(inventory.inventory_gui)
