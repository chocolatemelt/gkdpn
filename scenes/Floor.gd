extends TileMap

func _ready():
	pass


# later: highlight by showing a cell at this position?
func _process(delta):
	var mousePos = get_global_mouse_position()
	var loc = world_to_map(mousePos)
	var cell = get_cell(loc.x, loc.y)
	# print(cell, loc.x, loc.y)
