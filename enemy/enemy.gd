extends CharacterBody3D

var health : float = 100.0
@onready var enemy: CharacterBody3D = $"."
var distance: float  # Type annotation added
var player = null
const SPEED : float = 3.0 
@export var player_path : NodePath
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D

var can_attack: bool = true  # Added attack cooldown flag

func _ready() -> void:
	player = get_node(player_path)

func _physics_process(delta: float) -> void:  # Changed from _process to _physics_process
	if player == null:
		return
		
	look_at(player.global_position, Vector3.UP)
	distance = player.global_position.distance_to(global_position)  # Simplified distance calculation
	
	if distance > 10:
		nav_agent.set_target_position(player.global_position)  # Changed from global_transform.origin
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_position).normalized() * SPEED
		move_and_slide()
	elif can_attack:  # Only attack if cooldown is finished
		attack_player()

func attack_player() -> void:
	if player == null:
		return
		
	can_attack = false  # Start attack cooldown
	
	# Configure raycast
	# Process raycast collision
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player and player.has_method("damage"):
			player.damage(10)
			print("Düşman isabet etti!")
		else:
			print("Ray başka bir nesneye çarptı!")
	else:
		print("Ray hiçbir nesneye çarpmadı!")
	
	# Play attack animation if available
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("attack")
	
	# Create attack cooldown timer
	await get_tree().create_timer(1.5).timeout
	can_attack = true  # Reset attack cooldown
	
func damage(hit : float) -> void:
	health -= hit
	print(health)
	if health <= 0:
		queue_free() 
