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
		self.get_parent().get_parent().get_node("UI").selected_item = "inv_sniper0"
		self.get_parent().get_parent().get_node("UI/item_inactive_button").text = "Sniper0"
		print("Sniper select")
		overview.get_node("item/rifle0_mat").visible = 0
		overview.get_node("item/sniper_2").visible = 1
		overview.get_node("item").mesh = load("")
	elif self.is_in_group("inv_rifle0"):
		self.get_parent().get_parent().get_node("UI").selected_item = "inv_rifle0"
		self.get_parent().get_parent().get_node("UI/item_inactive_button").text = "Rifle0"
		print("Rifle select")
		overview.get_node("item").mesh = load("")
		overview.get_node("item/sniper_2").visible = 0
		overview.get_node("item/rifle0_mat").visible = 1
		#overview.get_node("item").mesh = load("res://overview_meshes/item_rifle0.tres")
