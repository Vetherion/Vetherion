extends State

func _ready() -> void:
	print("inv")

func enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func exit() -> void:
	pass
