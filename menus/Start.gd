extends TextureRect

func _ready():
	pass

func _process(delta):
	pass

func _on_Start_mouse_entered():
	print("ooh")


func _on_Start_mouse_exited():
	print("ahh")


func _on_Start_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene("res://scenes/dungeon.tscn")
