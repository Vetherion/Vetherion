extends Node


func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/3D_Level.tscn") 


func _on_load_save_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn") 


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn") 


func _on_exit_pressed() -> void:
	get_tree().quit() 

func _on_new_game_pressed() -> void:
	pass # Replace with function body.
