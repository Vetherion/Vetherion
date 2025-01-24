#TODO: Add masks for various interactions.

extends RayCast3D

@export var inventory_script : Node
var anim_played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider != null and collider.get_parent() != null and collider.get_parent().is_in_group("inv_item"):
			%interaction.visible = 1
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
					inventory_script.add_to_inv(group_check)
				collider.get_parent().queue_free()
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
