extends TileMap

var hover_loc

func _ready():
	pass

# later: highlight by showing a cell at this position?
func _process(delta):
	var mousePos = get_global_mouse_position()
	hover_loc = world_to_map(mousePos)
	# var cell = get_cell(loc.x, loc.y)
	# print(cell, loc.x, loc.y)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var player = get_parent().get_node('Walls').get_node('Player')
			player.move(hover_loc)
