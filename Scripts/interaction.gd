#TODO: Add masks for various interactions.

extends RayCast3D

@export var inventory : Node
@export var dialogue: Node
@export var player: Node
var anim_played = false
var in_car = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider and collider.get_parent() and collider.get_parent().is_in_group("inv_item"):
			%interaction.visible = 1
			%interaction.get_node("Action").text = "take"
			if !anim_played:
				%anim.play("select_in")
				anim_played = true
			if Input.is_action_just_pressed("E"):
				var group_check: String
				for i in collider.get_parent().get_groups():
					if i == "inv_item":
						pass
					else:
						group_check = i
				if group_check:
					inventory.add_to_inv(group_check)
				collider.get_parent().queue_free()
			else:
				pass
		elif collider and collider.get_parent() and collider.get_parent().is_in_group("Car"):
			%interaction.visible = 1
			if !anim_played:
				%anim.play("select_in")
				anim_played = true
			%interaction.get_node("Action").text = "enter car"
			if !in_car:
				if Input.is_action_just_pressed("E"):
					player.queue_free()
					in_car = true
			else:
				pass
		elif collider and collider.get_parent() and collider.get_parent().is_in_group("npc"):
			%interaction.visible = 1
			if !anim_played:
				%anim.play("select_in")
				anim_played = true
			%interaction.get_node("Action").text = "interact"
			if Input.is_action_just_pressed("E"):
				dialogue.start_partial_dialogue("res://dialogues/example_dialogue.json")
			else:
				pass
		else:
			%interaction.visible = 0
			%anim.play("RESET")
			anim_played = false
	else:
		%interaction.visible = 0
		%anim.play("RESET")
		anim_played = false
