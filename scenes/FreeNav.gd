extends Node2D

var path : PoolVector2Array
var goal : Vector2
var cam_current: Camera2D


func toggle_camera():
	if $CamStatic.current:
		cam_current = $CamMouse
	elif $CamMouse.current:
		cam_current = $Player/CamFollow
	else:
		cam_current = $CamStatic
	cam_current.make_current()


func _ready():
	cam_current = $CamStatic
	set_physics_process(false)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			toggle_camera()
