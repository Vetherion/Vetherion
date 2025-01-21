extends Button


var dialogue_node

func _ready() -> void:
	dialogue_node = get_node("../../../../Dialogue")
func _on_focus_entered() -> void:
	$"../anim".play("select_in")


func _on_focus_exited() -> void:
	$"../anim".play("RESET")


func _on_pressed() -> void:
	dialogue_node.load_partial_dialogue(dialogue_node.current_dialogue, dialogue_node.current_focus)
	print(dialogue_node.current_dialogue) # Replace with function body.
