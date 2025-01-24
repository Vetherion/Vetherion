extends Node 

const RAY_LENGTH : float = 1.8

var inventory = {
	0: "void"
}
var item_count : int = 0
var is_inv_open : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("TAB"):
		if is_inv_open == false:
			get_node("../../HUD/SubViewportContainer/SubViewport/Inventory").visible = 1
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_inv_open = true
		else:
			get_node("../../HUD/SubViewportContainer/SubViewport/Inventory").visible = 0
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_inv_open = false

func add_to_inv(item_type) -> void:
	inventory[item_count + 1] = item_type
	item_count += 1
	print(inventory)
