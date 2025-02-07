extends Node3D

var initial_position: Vector2
var movement_position: Vector2

var focus = [0, 0]

var on_move = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SettingVariables.msaa3d:
		get_viewport().msaa_3d = SettingVariables.msaa3d
	if SettingVariables.fxaa:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		initial_position = event.position
		on_move = event["pressed"]
		#print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		if on_move:
			initial_position = event.position
			self.get_node("item").rotate(Vector3(0, 1, 0), (movement_position - initial_position).length()*sign(initial_position.x - movement_position.x)*0.005)
			#print((movement_position - click_position).length())
		movement_position = event.position
		#print("Mouse Motion at: ", event.position)
