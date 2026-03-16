extends CharacterBody3D

var _health : float = 100

func get_health() -> int:
	return _health 
	
func set_health(value:int) -> void:
	_health = clamp(value, 0, 100)
	
	if _health <= 0:
		die()
		
func die():
	queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func damage(hit : float) -> void:
	set_health(_health - hit)

	var tween = create_tween()
	tween.tween_property(get_node("HUD/Health2/Health"), "value", _health, 0.5).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(get_node("HUD/Health2"), "value", _health, 0.75).set_trans(Tween.TRANS_LINEAR)
