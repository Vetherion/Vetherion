# To be continued 
extends Node

var current_mission = ""
@onready var target_npc = get_node("../../MeshInstance3D2")
@export var camera: Camera3D
@export var exclamation: TextureRect
@export var padding: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_mission == "":
		# This part is created with the help of ChatGPT <---
		var viewport_size = $"../HUD/Exclamation".get_viewport_rect().size
		var target_position_3d = target_npc.global_transform.origin
		var screen_position = camera.unproject_position(target_position_3d)
		#var viewport_size = get_viewport_rect().size
	
		if camera.is_position_behind(target_position_3d):
			var screen_center = viewport_size/2
			var to_target = (screen_position - screen_center).normalized()
			screen_position = screen_center + to_target * (screen_center.x - padding)
		else:
			exclamation.show()
			exclamation.position = screen_position - (exclamation.size / 2)
		# Clamp position inside screen bounds
		screen_position.x = clamp(screen_position.x, padding, viewport_size.x - exclamation.size.x)
		screen_position.y = clamp(screen_position.y, padding, viewport_size.y - exclamation.size.y)

		exclamation.position = screen_position - (exclamation.size / 2)
		# --->
