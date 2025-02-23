extends Node 

@onready var col_one = get_node("VBoxContainer/1")
@onready var col_two = get_node("VBoxContainer/2")
@onready var col_thr = get_node("VBoxContainer/3")
@onready var col_fur = get_node("VBoxContainer/4")

var inventory = {
	0: "void"
}
var inventory_gui = {
	[1, 1]: "void",
	[1, 2]: "void",
	[1, 3]: "void",
	[1, 4]: "void",
	[2, 1]: "void",
	[2, 2]: "void",
	[2, 3]: "void",
	[2, 4]: "void",
	[3, 1]: "void",
	[3, 2]: "void",
	[3, 3]: "void",
	[3, 4]: "void",
	[4, 1]: "void",
	[4, 2]: "void",
	[4, 3]: "void",
	[4, 4]: "void"
}
var item_count : int = 0
var is_inv_open : bool = false
# Called when the node enters the scene tree for the first time.


func _process(delta : float) -> void:
	if Input.is_action_just_pressed("TAB"):
		if is_inv_open == false:
			self.visible = 1
			$"../OverviewContainer".visible = 1
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_inv_open = true
		else:
			self.visible = 0
			$"../OverviewContainer".visible = 0
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
				inventory_gui[[1, button_num]] = "inv_sniper0"
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
				inventory_gui[[1, button_num]] = "inv_rifle0"
		2:
			col_one.get_node(str(button_num)).add_to_group(item_type)
			if item_type == "inv_sniper0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
				inventory_gui[[2, button_num]] = "inv_sniper0"
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
				inventory_gui[[2, button_num]] = "inv_rifle0"

		3:
			col_one.get_node(str(button_num)).add_to_group(item_type)
			if item_type == "inv_sniper0":
				inventory_gui[[2, button_num]] = "inv_sniper0"
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
				inventory_gui[[3, button_num]] = "inv_rifle0"
		4:
			col_one.get_node(str(button_num)).add_to_group(item_type)
			if item_type == "inv_sniper0":
				inventory_gui[[3, button_num]] = "inv_sniper0"
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_sniper0.png")

			elif item_type == "inv_rifle0":
				col_one.get_node(str(button_num)).icon = load("res://external/icons/icon_rifle0.png")
				inventory_gui[[4, button_num]] = "inv_rifle0"

	print(item_type)
	
func load_gui():
	print(inventory_gui)
	for i in inventory_gui.keys():
		print(inventory_gui[i])
		match i:
			[1, 1]:
				col_one.get_node(str(1)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_one.get_node(str(1)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_one.get_node(str(1)).icon = load("res://external/icons/icon_rifle0.png")
			[1, 2]:
				col_one.get_node(str(2)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_one.get_node(str(2)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_one.get_node(str(2)).icon = load("res://external/icons/icon_rifle0.png")
			[1, 3]:
				col_one.get_node(str(3)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_one.get_node(str(3)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_one.get_node(str(3)).icon = load("res://external/icons/icon_rifle0.png")
			[1, 4]:
				col_one.get_node(str(4)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_one.get_node(str(4)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_one.get_node(str(4)).icon = load("res://external/icons/icon_rifle0.png")
			[2, 1]:
				col_two.get_node(str(1)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_two.get_node(str(1)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_two.get_node(str(1)).icon = load("res://external/icons/icon_rifle0.png")
			[2, 2]:
				col_two.get_node(str(2)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_two.get_node(str(2)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_two.get_node(str(2)).icon = load("res://external/icons/icon_rifle0.png")
			[2, 3]:
				col_two.get_node(str(3)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_two.get_node(str(3)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_two.get_node(str(3)).icon = load("res://external/icons/icon_rifle0.png")
			[2, 4]:
				col_two.get_node(str(4)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_two.get_node(str(4)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_two.get_node(str(4)).icon = load("res://external/icons/icon_rifle0.png")
			[3, 1]:
				col_thr.get_node(str(1)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_thr.get_node(str(1)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_thr.get_node(str(1)).icon = load("res://external/icons/icon_rifle0.png")
			[3, 2]:
				col_thr.get_node(str(2)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_thr.get_node(str(2)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_thr.get_node(str(2)).icon = load("res://external/icons/icon_rifle0.png")
			[3, 3]:
				col_thr.get_node(str(3)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_thr.get_node(str(3)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_thr.get_node(str(3)).icon = load("res://external/icons/icon_rifle0.png")
			[3, 4]:
				col_thr.get_node(str(4)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_thr.get_node(str(4)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_thr.get_node(str(4)).icon = load("res://external/icons/icon_rifle0.png")
			[4, 1]:
				col_fur.get_node(str(1)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_fur.get_node(str(1)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_fur.get_node(str(1)).icon = load("res://external/icons/icon_rifle0.png")
			[4, 2]:
				col_fur.get_node(str(2)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_fur.get_node(str(2)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_fur.get_node(str(2)).icon = load("res://external/icons/icon_rifle0.png")
			[4, 3]:
				col_fur.get_node(str(3)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_fur.get_node(str(3)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_fur.get_node(str(3)).icon = load("res://external/icons/icon_rifle0.png")
			[4, 4]:
				col_fur.get_node(str(4)).add_to_group(inventory_gui[i])
				if inventory_gui[i] == "inv_sniper0":
					col_fur.get_node(str(4)).icon = load("res://external/icons/icon_sniper0.png")
				elif inventory_gui[i] == "inv_rifle0":
					col_fur.get_node(str(4)).icon = load("res://external/icons/icon_rifle0.png")
