extends TileMap

var last_position
var mouse_map_position

func _ready():
	pass

func get_cell_position(pos: Vector2) -> Vector2:
	return world_to_map(to_local(pos))

func _process(_delta):
	last_position = mouse_map_position
	mouse_map_position = get_cell_position(get_global_mouse_position())
	if(last_position):
		set_cellv(last_position, -1)
	set_cellv(mouse_map_position, 1)
	
