extends Node2D

var cost_map: Dictionary = {}
var alpha_step: float = 0.1
var path: PoolIntArray = PoolIntArray() setget _set_path

onready var tile_map: TileMap = get_parent()
onready var corner_offsets: PoolVector2Array = PoolVector2Array([
	Vector2.ZERO,
	tile_map.cell_size / 2,
	Vector2(0, tile_map.cell_size.y),
	Vector2(-tile_map.cell_size.x / 2, tile_map.cell_size.y / 2),
])


func idx_to_corners(idx: int):
	var pos = tile_map.idx_to_pos[idx]
	var world_pos = tile_map.map_to_world(pos)
	world_pos = Vector2(world_pos.x, world_pos.y)
	var corners = PoolVector2Array()
	for offset in corner_offsets:
		corners.push_back(world_pos + offset)
	return corners


func _draw():
	if path.size() > 1:
		var prev_pos = tile_map.idx_to_world(path[0])
		for i in range(1, path.size()):
			var curr_pos = tile_map.idx_to_world(path[i])
			draw_line(
				prev_pos,
				curr_pos,
				Color.green,
				8.0
			)
			draw_circle(prev_pos, 12.0, Color.green)
			prev_pos = curr_pos
		draw_circle(prev_pos, 16.0, Color.blue)

	for idx in cost_map.keys():
		draw_colored_polygon(idx_to_corners(idx), Color(1, 0, 0, alpha_step * cost_map[idx]))


func update_params(costs: Dictionary, movement: int):
	cost_map = costs
	alpha_step = 1.0 / (movement * 2)
	path = PoolIntArray()
	update()


func _set_path(value: PoolIntArray):
	path = value
	if path.size() > 1:
		update()
