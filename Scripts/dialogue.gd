#DISCLAIMER: This dialogue system has not finished. It may have many bugs, and it is not suitable for usage at the time. 

#TODO: Fix the grab_focus bug
#TODO: Fix the color bug

#DONE TODO: Fix the stacking bug (Fixed but should be better way)
#DONE TODO: Add crisp text (Added but not that good)
extends Node

@onready var current_dialogue = ""
@export var label_scene: PackedScene
@export var button_scene: PackedScene

var is_done = false
var buttons: Array[Object]
var current_focus = 0
var responder: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	start_partial_dialogue("res://dialogues/example_dialogue.json")
	%Dialogue.visible = 0 #<---------------------------------------------------------------DEGISECEK                 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("arrow_down") and is_done:
		buttons[current_focus].get_node("anim").play("RESET")
		current_focus = current_focus + 1
		if current_focus == len(buttons):
			current_focus = 0
		buttons[current_focus].get_node("button").grab_focus()
	elif Input.is_action_just_pressed("arrow_up") and is_done:
		buttons[current_focus].get_node("anim").play("RESET")
		current_focus = current_focus - 1
		if current_focus == -1:
			current_focus = len(buttons) - 1
		buttons[current_focus].get_node("button").grab_focus()
		

func start_partial_dialogue(dialogue_path) -> void:
	%Dialogue.visible = 1

	var text = FileAccess.get_file_as_string(dialogue_path)
	var dict = JSON.parse_string(text)
	current_dialogue = dict
	var words = dict["start_text"].split(" ")
	responder = dict["responder"]
	#words.insert(0, responder + ":")
	$VBoxContainer/Responder.text = responder
	for i in range(len(words)):
		var label = label_scene.instantiate()
		%HBoxContainer.add_child(label)
		label.text = words[i]
		label.modulate = 0
		#label.get_node("anim").play("fade_out")
		
	for i in %HBoxContainer.get_children():
		i.get_node("anim").play("fade_out")
		await get_tree().create_timer(0.3).timeout
	
	is_done = true

	for i in range(len(dict["option_tree"].keys())):
		var button = button_scene.instantiate()
		%VBoxContainer.add_child(button)
		# b1 is the button scene in the button container
		button.get_node("button").text = dict["option_tree"].keys()[i]
		buttons.append(button)
		button.get_node("anim").play("fade_out")
		await get_tree().create_timer(0.2).timeout
	
	buttons[0].grab_focus()
	buttons[0].get_node("anim").play("select_in")
	

func load_partial_dialogue(dialogue, index):
	
	var dict = current_dialogue
	
	var current = dict["option_tree"].values()[index]
	current_dialogue = current
	if typeof(current) == TYPE_DICTIONARY:
		for i in %VBoxContainer.get_children():
			if i.is_in_group("button") and i != null:
				i.queue_free()
				i = null
		
		for i in %HBoxContainer.get_children():
			if i.is_in_group("label") and i != null:
				i.queue_free()
				i = null
				
		# !bad architecture
		await get_tree().create_timer(0.01).timeout
		# label update
		var words = current["start_text"].split(" ")
		$VBoxContainer/Responder.text = responder
		for i in range(len(words)):
			var label = label_scene.instantiate()
			%HBoxContainer.add_child(label)
			label.text = words[i]
			label.modulate = 0
		
		for i in %HBoxContainer.get_children():
			i.get_node("anim").play("fade_out")
			await get_tree().create_timer(0.3).timeout
		
		
		buttons.clear()
		current_focus = 0
		for i in range(len(current["option_tree"].keys())):
			var button = button_scene.instantiate()
			%VBoxContainer.add_child(button)
			button.get_node("button").text = current["option_tree"].keys()[i]
			buttons.append(button)
			button.get_node("anim").play("fade_out")
			await get_tree().create_timer(0.2).timeout
		buttons[0].grab_focus()
		buttons[0].get_node("anim").play("select_in")
	else:
		if typeof(current) == TYPE_STRING:
			if current.right(3) == "END":
				$"../../..".visible = 0
				%Dialogue.visible = 0
			else:
				for i in %VBoxContainer.get_children():
					if i.is_in_group("button") and i != null:
						i.queue_free()
						i = null
				for i in %HBoxContainer.get_children():
					if i.is_in_group("label") and i != null:
						i.queue_free()
						i = null
				await get_tree().create_timer(0.01).timeout
				var words = current["start_text"].split(" ")
				$VBoxContainer/Responder.text = responder
				for i in range(len(words)):
					var label = label_scene.instantiate()
					%HBoxContainer.add_child(label)
					label.text = words[i]
					label.modulate = 0
				for i in %HBoxContainer.get_children():
					i.get_node("anim").play("fade_out")
					await get_tree().create_timer(0.3).timeout
		else:
			for i in %VBoxContainer.get_children():
				if i.is_in_group("button") and i != null:
					i.queue_free()
					i = null
			for i in %HBoxContainer.get_children():
				if i.is_in_group("label") and i != null:
					i.queue_free()
					i = null
			await get_tree().create_timer(0.01).timeout
				
			var words = current["start_text"].split(" ")
			$VBoxContainer/Responder.text = responder
			for i in range(len(words)):
				var label = label_scene.instantiate()
				%HBoxContainer.add_child(label)
				label.text = words[i]
				label.modulate = 0
			for i in %HBoxContainer.get_children():
				i.get_node("anim").play("fade_out")
				await get_tree().create_timer(0.3).timeout


func _on_sub_viewport_gui_focus_changed(node: Control) -> void:
	print(node) # Replace with function body.
