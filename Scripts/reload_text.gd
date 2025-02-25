extends Node

@onready var level1 = get_node("../../../../../../../3D_Level")
@onready var container = get_node("../../../../../../player/HUD/Cnt/Panel/Cnt/")
@onready var reload = get_node("../../../../../../player/HUD/Cnt/Panel/reload")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	reload.visible = 0
	container.visible = 1
	if self.get_parent().name == "Rifle":
		container.get_node("Ammo").text = str(level1.magazine_rifle)
		container.get_node("Ammo_total").text = str(level1.ammo_rifle)
	elif self.get_parent().name == "Sniper":
		container.get_node("Ammo").text = str(level1.magazine_sniper)
		container.get_node("Ammo_total").text = str(level1.ammo_sniper)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	reload.visible = 1
	container.visible = 0
