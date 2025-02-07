extends Node 

@onready var col_one = get_node("../../HUD/InventoryContainer/SubViewport/Inventory/VBoxContainer/1")
@onready var col_two = get_node("../../HUD/InventoryContainer/SubViewport/Inventory/VBoxContainer/2")
@onready var col_thr = get_node("../../HUD/InventoryContainer/SubViewport/Inventory/VBoxContainer/3")
@onready var col_fur = get_node("../../HUD/InventoryContainer/SubViewport/Inventory/VBoxContainer/4")

var inventory = {
	0: "void"
}
var item_count : int = 0
var is_inv_open : bool = false
# Called when the node enters the scene tree for the first time.


func _process(delta : float) -> void:
	if Input.is_action_just_pressed("TAB"):
		if is_inv_open == false:
			get_node("../../HUD/InventoryContainer").visible = 1
			get_node("../../HUD/OverviewContainer").visible = 1
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_inv_open = true
		else:
			get_node("../../HUD/InventoryContainer").visible = 0
			get_node("../../HUD/OverviewContainer").visible = 0
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_inv_open = false

	
func add_to_inv(item_type) -> void:
	inventory[item_count + 1] = item_type
	item_count += 1
	var button_num = 0
	var col_num = 1
	var is_found = false
	
	while !is_found:
		button_num += 1
		
		match col_num:
			1:
				if col_one.get_node(str(button_num)) and col_one.get_node(str(button_num)).get_groups() == []:
					is_found = true
				if button_num == 4:
					col_num += 1
					button_num = 0
			2:
				if col_two.get_node(str(button_num)) and col_two.get_node(str(button_num)).get_groups() == []:
					is_found = true
				if button_num == 4:
					col_num += 1
					button_num = 0
			3:
				if col_thr.get_node(str(button_num)) and col_thr.get_node(str(button_num)).get_groups() == []:
					is_found = true
				if button_num == 4:
					col_num += 1
					button_num = 0
			4:
				if col_fur.get_node(str(button_num)) and col_fur.get_node(str(button_num)).get_groups() == []:
					is_found = true
				if button_num == 4:
					print("not enough space in inventory")
					break
	
	match col_num:
		1:
			col_one.get_node(str(button_num)).add_to_group(item_type)
			if item_type == "inv_sniper0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
		2:
			if item_type == "inv_sniper0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
		3:
			if item_type == "inv_sniper0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
		4:
			if item_type == "inv_sniper0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
	print(item_type)
