extends CenterContainer

@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.25
@export var RETICLE_DISTANCE : float = 2.0

func _ready() -> void:
	queue_redraw()
	
func _process(delta : float) -> void:
	adjust_rectile_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0),1.0,Color.WHITE)
	
func adjust_rectile_lines() -> void:
	var vel : Vector3 = PLAYER_CONTROLLER.get_real_velocity()
	var origin : Vector3 = Vector3(0,0,0)
	var pos : Vector2 = Vector2(0,0)
	var speed : float = origin.distance_to(vel)

#Adjust Reticle Line Position CHANGE
	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
