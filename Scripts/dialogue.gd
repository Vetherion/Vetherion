#DISCLAIMER: This dialogue system has not finished. It may have many bugs, and it is not suitable for usage at the time. 
extends Node

@onready var current_dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_partial_dialogue("res://dialogues/example_dialogue.json")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_partial_dialogue(dialogue_path):
	%ItemList.grab_focus()
	var text = FileAccess.get_file_as_string(dialogue_path)
	var dict = JSON.parse_string(text)
	current_dialogue = dict
	var label = get_node("./SubViewportContainer/SubViewport/Label")
	var itemlist = get_node("./SubViewportContainer/SubViewport/ItemList")
	
	label.text = dict["start_text"]
	for i in range(len(dict["option_tree"].keys())):
		itemlist.add_item(dict["option_tree"].keys()[i])

func load_partial_dialogue(dialogue, index):
	%ItemList.grab_focus()
	var dict = current_dialogue
	var label = get_node("./SubViewportContainer/SubViewport/Label")
	var itemlist = get_node("./SubViewportContainer/SubViewport/ItemList")
	
	var current = dict["option_tree"].values()[index]
	current_dialogue = current
	if typeof(current) == TYPE_DICTIONARY:
		label.text = current["start_text"]
		
		itemlist.clear()
		for i in range(len(current["option_tree"].keys())):
			itemlist.add_item(current["option_tree"].keys()[i])
	else:
		if typeof(current) == TYPE_STRING:
			%ItemList.visible = 0 
			%ItemList.release_focus()
			label.text = current
		else:
			label.text = current["start_text"]

func _on_item_list_item_activated(index: int) -> void:
	load_partial_dialogue(current_dialogue, index)
