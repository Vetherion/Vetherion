extends Control

@export var player: CharacterBody3D
@export var state_machine: Node
@onready var level0 = player.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nstamina: "  + str(state_machine.stamina) + "\nHP: " + str(player.health) + "\npos: " + str(player.position) + "\nvel: " + str(player.velocity) + "\nspd: " + str(player.velocity.length())


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
		state_machine.initial_stamina = 99999.99 
		state_machine.stamina = 99999.99 
	else:
		state_machine.initial_stamina = 100.00
		state_machine.stamina = 100.00
