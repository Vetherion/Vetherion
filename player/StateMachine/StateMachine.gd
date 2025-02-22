extends Node

@export var body : CharacterBody3D
@export var initialState : STATES

enum STATES {Move, Diyalogue, Inventory}

var currentState : STATES
var previousState : STATES  # Track previous state

func _ready() -> void:
	currentState = initialState if initialState else STATES.Move
	previousState = currentState
	get_children()[currentState].set_active(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("TAB"):
		match currentState:
			STATES.Move:
				change_state(STATES.Inventory)
			STATES.Inventory:
				change_state(STATES.Move)
		
func change_state(newState):
	if newState == currentState: return
	
	previousState = currentState  # Store the previous state
	get_children()[currentState].set_active(false)
	
	# Small delay before activating new state to ensure clean transition
	await get_tree().create_timer(0.05).timeout
	
	currentState = newState
	get_children()[currentState].set_active(true)
