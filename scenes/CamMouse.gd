extends Camera2D


func _input(event):
	if current and event is InputEventMouseMotion:
		var mouse_offset = (event.position - get_viewport().size / 2)
		position = lerp(Vector2(), mouse_offset.normalized() * 500, mouse_offset.length() / 1000)
