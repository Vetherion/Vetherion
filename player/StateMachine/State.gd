extends Node
class_name State

var active : bool = false
var stateMachine = get_parent()
var player

var STATES

func _ready() -> void:
	player = get_parent().body
	STATES = get_parent().STATES
	
	set_active(false)
	
func set_active(boolean):
	if boolean:
		enter()
	else:
		exit()
		
	set_physics_process(boolean)
	set_process(boolean)

func enter():
	pass
	
func exit():
	pass
