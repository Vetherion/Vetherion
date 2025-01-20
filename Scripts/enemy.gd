extends CharacterBody3D
var health : float = 100.0

func damage(hit : float) -> void:
	health -= hit
	print(health)
	if health <= 0:
		queue_free()
