extends CanvasLayer


func _input(event):
	if event is InputEventMouseMotion:
		$XY/Mouse.set_text(str("Mouse: ", event.position))

func _process(delta):
	
	$XY/Player.set_text(str("Player: ", $"../Player".position))
	$XY/Cam.set_text(str("Cam: ", $"..".cam_current.get_camera_position()))
