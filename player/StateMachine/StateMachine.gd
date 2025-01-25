extends Node

@export var body : CharacterBody3D
@export var initialState : STATES

enum STATES {Move, Diyalogue, Inventory}

var currentState : STATES


func _ready() -> void:
	currentState = initialState if initialState else STATES.Move
	get_children()[currentState].set_active(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("TAB"):
		match currentState:
			STATES.Move:
				change_state(STATES.Inventory)
			STATES.Inventory:
				change_state(STATES.Move)
		
func _physics_process(delta: float) -> void:
	#if body.animationPause : return
	pass
func change_state(newState):
	if newState == currentState: return
	
	get_children()[currentState].set_active(false)
	currentState = newState
	get_children()[currentState].set_active(true)
