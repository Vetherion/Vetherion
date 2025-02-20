extends Node2D

@onready var enemies = get_node("../../../../../NavigationRegion3D/Enemies")
@onready var player = get_node("../../../../../player")

const SCALE = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player.rotation = -player.get_node("CameraPivot").rotation.y
	if enemies.get_node("Enemy"):
		#TODO: Make it for every case
		if enemies.get_node("Enemy").position.z - player.position.z > 0:
			$Npc_enemy.position.y = 128 + SCALE*(enemies.get_node("Enemy").position.z - player.position.z)
		else:
			$Npc_enemy.position.y = 128 + SCALE*(enemies.get_node("Enemy").position.z - player.position.z)
		if enemies.get_node("Enemy").position.x - player.position.x > 0:
			$Npc_enemy.position.x = 128 + SCALE*(enemies.get_node("Enemy").position.x - player.position.x)
		else:
			$Npc_enemy.position.x = 128 + SCALE*(enemies.get_node("Enemy").position.x - player.position.x)
	elif !enemies.get_node("Enemy") and $Npc_enemy:
		$Npc_enemy.queue_free()
		
		
		
