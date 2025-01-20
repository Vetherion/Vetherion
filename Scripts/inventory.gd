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
			get_node("../../Inventory").visible = 1
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_inv_open = true
		else:
			get_node("../../Inventory").visible = 0
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_inv_open = false

func is_eligible() -> MeshInstance3D:
	var mousePos : Vector2 = get_viewport().get_size()/2
	var camera3d : Camera3D = %Camera3D
	var from : Vector3 = camera3d.project_ray_origin(mousePos)
	var to : Vector3 = from + camera3d.project_ray_normal(mousePos) * RAY_LENGTH
	
	var new_intersection : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var intersection : Dictionary = camera3d.get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if intersection and intersection.collider.get_parent().is_in_group("inv_item"):
		return intersection.collider.get_parent()
	else:
		return null

func add_to_inv(item_type) -> void:
	inventory[item_count + 1] = item_type
	item_count += 1
	get_node("../../Inventory/SubViewportContainer/SubViewport/ItemList").add_item(item_type)
