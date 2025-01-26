extends Button

@export var overview: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if self.is_in_group("inv_sniper0"):
		print("load1")
		overview.get_node("item").mesh = load("res://overview_meshes/item_sniper0.tres")
	elif self.is_in_group("inv_rifle0"):
		print("load2")
		overview.get_node("item").mesh = load("res://overview_meshes/item_rifle0.tres")
