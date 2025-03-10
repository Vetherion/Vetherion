extends Control

@export var player: CharacterBody3D
@export var dialogue: Control
@export var move_state_machine: Node
@export var real_state_machine: Node
@onready var level0 = player.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + \
			  "stamina: " + str(move_state_machine.stamina) + "\n" + \
			  "HP: " + str(player.health) + "\n" + \
			  "pos: " + str(player.position) + "\n" + \
			  "cam rotation: " + str(%CameraPivot.rotation) + "\n" + \
			  "wep rotation: " + str($"../CameraPivot/Recoil/Weapon_Ray".rotation) + "\n" + \
			  "vel: " + str(player.velocity) + "\n" + \
			  "spd: " + str(player.velocity.length()) + "\n" + \
			  "current_state: " + (real_state_machine.string_cur_state if real_state_machine.string_cur_state != "move" else ("Move" if Global.CurrentMoveState == "Move" else "Jump"))

#infinite ammo
func _on_check_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		level0.ammo_rifle = 9999
		level0.magazine_rifle = 9999
		level0.ammo_sniper = 9999
		level0.magazine_sniper = 9999
	else:
		level0.ammo_rifle = 90
		level0.magazine_rifle = 30
		level0.ammo_sniper = 30
		level0.magazine_sniper = 5

#full hp
func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		player.health = 99999.99 
	else:
		player.health = 100.00


func _on_infinite_stamina_toggled(toggled_on: bool) -> void:
	if toggled_on:
		move_state_machine.initial_stamina = 99999.99 
		move_state_machine.stamina = 99999.99 
	else:
		move_state_machine.initial_stamina = 100.00
		move_state_machine.stamina = 100.00
