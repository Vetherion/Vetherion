extends CharacterBody3D

var health : float = 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func damage(hit : float) -> void:
	health -= hit

	var tween = create_tween()
	tween.tween_property(get_node("HUD/Health2/Health"), "value", health, 0.5).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(get_node("HUD/Health2"), "value", health, 0.75).set_trans(Tween.TRANS_LINEAR)
	
	if health <= 0:
		queue_free() 
		
