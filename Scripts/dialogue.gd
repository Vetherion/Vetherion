#DISCLAIMER: This dialogue system has not finished. It may have many bugs, and it is not suitable for usage at the time. 
extends Node

@onready var current_dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_partial_dialogue("res://dialogues/example_dialogue.json")
	%Dialogue.visible = 0 #<---------------------------------------------------------------DEGISECEK                 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_partial_dialogue(dialogue_path):
	%Dialogue.visible = 1
	%ItemList.visible = 0
	var text = FileAccess.get_file_as_string(dialogue_path)
	var dict = JSON.parse_string(text)
	current_dialogue = dict
	var label = get_node("./SubViewportContainer/SubViewport/Label")
	var itemlist = get_node("./SubViewportContainer/SubViewport/ItemList")
	
	for i in range(len(dict["start_text"]) + 1):
		label.text = dict["start_text"].left(i)  
		await get_tree().create_timer(0.05).timeout 
	#TODO: Add fade in fade out.
	%ItemList.visible = 1
	%ItemList.grab_focus()
	for i in range(len(dict["option_tree"].keys())):
		itemlist.add_item(dict["option_tree"].keys()[i])

func load_partial_dialogue(dialogue, index):
	%ItemList.grab_focus()
	%ItemList.clear()
	var dict = current_dialogue
	var label = get_node("./SubViewportContainer/SubViewport/Label")
	var itemlist = get_node("./SubViewportContainer/SubViewport/ItemList")
	
	var current = dict["option_tree"].values()[index]
	current_dialogue = current
	if typeof(current) == TYPE_DICTIONARY:
		for i in range(len(current["start_text"]) + 1):
			label.text = current["start_text"].left(i)
			await get_tree().create_timer(0.05).timeout 
		
		itemlist.clear()
		for i in range(len(current["option_tree"].keys())):
			itemlist.add_item(current["option_tree"].keys()[i])
	else:
		if typeof(current) == TYPE_STRING:
			if current.right(3) == "END":
				%Dialogue.visible = 0
			else:
				%ItemList.visible = 0 
				%ItemList.release_focus()
				for i in range(len(current) + 1):
					label.text = current.left(i)  
					await get_tree().create_timer(0.05).timeout 
		else:
			for i in range(len(current["start_text"]) + 1):
				label.text = current["start_text"].left(i)  
				await get_tree().create_timer(0.05).timeout 

func _on_item_list_item_activated(index: int) -> void:
	load_partial_dialogue(current_dialogue, index)
