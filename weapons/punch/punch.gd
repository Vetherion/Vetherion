extends WeaponClass

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_ray: RayCast3D = get_parent().get_parent().get_node("Weapon_Ray")
@onready var player: CharacterBody3D = get_parent().get_parent().get_parent().get_parent()
@onready var camerapivot: Node3D = get_parent().get_parent().get_parent()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click") and animation_player.is_playing() == false:
		animation_player.play("fire")
		if weapon_ray.is_colliding():
			var collider = weapon_ray.get_collider()
			if collider and collider.is_in_group("Enemy"):
				collider.damage(50)
