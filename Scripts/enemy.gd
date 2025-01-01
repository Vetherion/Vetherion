extends CharacterBody3D
var health : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func damage(hit : float):
	health -= hit
	print(health)
	if health <= 0:
		queue_free()
