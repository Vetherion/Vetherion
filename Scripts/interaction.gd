#TODO: Add masks for various interactions.

extends RayCast3D

@export var inventory : Node
@export var dialogue: Node
@export var player: Node
@export var camera: Camera3D
var anim_played = false
var in_car = false
var in_dialogue = false

@onready var character_mesh: MeshInstance3D = $"../../../sniperscope"
@onready var character_collision: CollisionShape3D = $"../../../CollisionShape3D"
@onready var character_camera: WeaponClass = $"../../../CameraPivot/Recoil/Camera3D"
@onready var car: VehicleBody3D = $"../../../../NavigationRegion3D/Car"

const EXIT_OFFSET: Vector3 = Vector3(-1.5, 0.5, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_car:
		if Input.is_action_just_pressed("E"):
			exit_car()
			in_car = false
	if is_colliding():
		var collider = get_collider()
		if collider and collider.get_parent() and collider.get_parent().is_in_group("inv_item"):
			%interaction.visible = 1
			var target_position_3d = collider.global_transform.origin
			var screen_position = camera.unproject_position(target_position_3d)
			%interaction.position = screen_position - Vector2(650,650)
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
			var target_position_3d = collider.global_transform.origin
			var screen_position = camera.unproject_position(target_position_3d)
			%interaction.position = screen_position - Vector2(650,650)
			if !anim_played:
				%anim.play("select_in")
				anim_played = true
			%interaction.get_node("Action").text = "enter car"
			if !in_car:
				if Input.is_action_just_pressed("E"):
					enter_car()
					in_car = true
			else:
				pass
		elif collider and collider.get_parent() and collider.get_parent().is_in_group("npc"):
			var target_position_3d = collider.global_transform.origin
			var screen_position = camera.unproject_position(target_position_3d)
			%interaction.position = screen_position - Vector2(650,650)
			if in_dialogue:
				%interaction.visible = 0
			else:
				%interaction.visible = 1
			if !anim_played:
				%anim.play("select_in")
				anim_played = true
			%interaction.get_node("Action").text = "interact"
			if Input.is_action_just_pressed("E") and Global.CurrentMoveState != "Jump":
				if !in_dialogue:
					dialogue.start_partial_dialogue(collider.get_parent(), "res://dialogues/example_dialogue.json")
				in_dialogue = true
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

func enter_car():
	character_mesh.visible = false
	character_collision.disabled = true
	character_camera.current = false
	
func exit_car():
	var car_rotation_basis: Basis = car.global_transform.basis
	var car_position: Vector3 = car.global_position
	var offset_global: Vector3 = car_rotation_basis * EXIT_OFFSET
	var spawn_position: Vector3 = car_position + offset_global
	player.global_position = spawn_position
	character_mesh.visible = true
	character_collision.disabled = false
	character_camera.current = true
