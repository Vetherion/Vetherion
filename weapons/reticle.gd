extends CenterContainer

@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.29
@export var RETICLE_DISTANCE : float = 2.0

var distance : float = 10.0

func _ready() -> void:
	queue_redraw()

func _process(delta : float) -> void:
	adjust_reticle_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0), 1.0, Color.WHITE)
	
func adjust_reticle_lines() -> void:
	var pos1 : Vector2 = Vector2(0,-distance)
	var pos2 : Vector2 = Vector2(distance,0)
	var pos3 : Vector2 = Vector2(0,distance)
	var pos4 : Vector2 = Vector2(-distance,0)
	var speed : float = AmmocountVariable.ammocount

	# Yeni Tween oluştur ve işlemleri paralel çalıştır
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# Tüm Reticle çizgilerini aynı anda hareket ettir
	if RETICLE_LINES.size() >= 4:
		tween.tween_property(RETICLE_LINES[0], "position", pos1 + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
		tween.tween_property(RETICLE_LINES[1], "position", pos2 + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
		tween.tween_property(RETICLE_LINES[2], "position", pos3 + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
		tween.tween_property(RETICLE_LINES[3], "position", pos4 + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
