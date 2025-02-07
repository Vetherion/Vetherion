extends Control

@export var setting_varriables: Script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_to_mainmenu_pressed() -> void:
	if $VBoxContainer/MSAA.selected == 0:
		pass
	elif $VBoxContainer/MSAA.selected == 1:
		SettingVariables.msaa3d = Viewport.MSAA_2X
	elif $VBoxContainer/MSAA.selected == 2:
		SettingVariables.msaa3d = Viewport.MSAA_4X
	elif $VBoxContainer/MSAA.selected == 3:
		SettingVariables.msaa3d = Viewport.MSAA_8X
	
	SettingVariables.fxaa = $VBoxContainer/FXAA.button_pressed
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") # Replace with function body.
