extends Node 
@onready var player: CharacterBody3D = $".."
@onready var StateMachine = player.get_node("StateMachine")

@onready var columns = {
	1: get_node("VBoxContainer/1"),
	2: get_node("VBoxContainer/2"),
	3: get_node("VBoxContainer/3"),
	4: get_node("VBoxContainer/4")
}

var inventory = { 0: "void" }
var inventory_gui = {}
var item_count : int = 0
var is_inv_open : bool = false

func _ready():
	# Envanter GUI başlangıç değerlerini ayarla
	for col in range(1, 5):
		for row in range(1, 5):
			inventory_gui[[col, row]] = "void"

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("TAB"):
		toggle_inventory()

func toggle_inventory():
	is_inv_open = !is_inv_open
	self.visible = int(is_inv_open)
	$"../OverviewContainer".visible = int(is_inv_open)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if is_inv_open else Input.MOUSE_MODE_CAPTURED

func add_to_inv(item_type) -> void:
	inventory[item_count + 1] = item_type
	item_count += 1
	
	var position = find_empty_slot()
	if position:
		var col_num = position[0]
		var button_num = position[1]
		update_inventory_slot(col_num, button_num, item_type)
	else:
		print("not enough space in inventory")

func find_empty_slot():
	for col_num in range(1, 5):
		for button_num in range(1, 5):
			if columns[col_num].get_node(str(button_num)) and columns[col_num].get_node(str(button_num)).get_groups() == []:
				return [col_num, button_num]
	return null

func update_inventory_slot(col_num, button_num, item_type):
	var button = columns[col_num].get_node(str(button_num))
	button.add_to_group(item_type)
	
	var icon_path = ""
	if item_type == "inv_sniper0":
		icon_path = "res://external/icons/icon_sniper0.png"
	elif item_type == "inv_rifle0":
		icon_path = "res://external/icons/icon_rifle0.png"
	
	if icon_path:
		button.icon = load(icon_path)
	
	inventory_gui[[col_num, button_num]] = item_type
	print(item_type)

func load_gui():
	print(inventory_gui)
	for key in inventory_gui.keys():
		var col_num = key[0]
		var button_num = key[1]
		var item_type = inventory_gui[key]
		
		if item_type != "void":
			var button = columns[col_num].get_node(str(button_num))
			button.add_to_group(item_type)
			
			if item_type == "inv_sniper0":
				button.icon = load("res://external/icons/icon_sniper0.png")
			elif item_type == "inv_rifle0":
				button.icon = load("res://external/icons/icon_rifle0.png")
