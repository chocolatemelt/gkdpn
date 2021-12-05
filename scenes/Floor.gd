extends TileMap

var mouse_global_position

func _ready():
	pass

func get_cell_global_position(pos: Vector2) -> Vector2:
	return to_global(map_to_world(world_to_map(to_local(pos))))

# TODO: highlight by showing a cell at this position?
func _process(delta):
	mouse_global_position = get_cell_global_position(get_global_mouse_position())


# TODO: avoid hitting walls?
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var player = get_parent().get_node('Walls').get_node('Player')
			player.move(mouse_global_position)
