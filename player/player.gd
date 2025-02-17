extends CharacterBody3D

var health : float = 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #now you can use your mouse 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE #now you cant use your mouse

func damage(hit : float) -> void:
	health -= hit
	print(health)
	if health <= 0:
		queue_free() 
		
