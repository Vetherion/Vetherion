extends Node3D

@export var settings: Control

var ammo_rifle : int = 90
var magazine_rifle : int = 30
const max_ammo_rifle : int = 90
const max_magazine_rifle : int = 30

var ammo_sniper : int = 30
var magazine_sniper : int = 5
const max_ammo_sniper : int = 30
const max_magazine_sniper : int = 5


func _ready() -> void:
	if SettingVariables.msaa3d:
		get_viewport().msaa_3d = SettingVariables.msaa3d
	if SettingVariables.fxaa:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
