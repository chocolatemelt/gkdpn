extends Node2D

var cost_map: Dictionary = {}
var target: Vector2 = Vector2.INF
var alpha_step: float = 0.1

onready var tile_map: TileMap = get_parent()
onready var corner_offsets: PoolVector2Array = PoolVector2Array([
	Vector2.ZERO,
	tile_map.cell_size / 2,
	Vector2(0, tile_map.cell_size.y),
	Vector2(-tile_map.cell_size.x / 2, tile_map.cell_size.y / 2),
])


func pos_to_corners(pos: Vector2):
	var world_pos = tile_map.map_to_world(pos)
	world_pos = Vector2(world_pos.x, world_pos.y)
	var corners = PoolVector2Array()
	for offset in corner_offsets:
		corners.push_back(world_pos + offset)
	return corners


func _draw():
	for pos in cost_map.keys():
		var color = Color(1, 0, 0, alpha_step * cost_map[pos])
		if pos == target:
			color  = Color(0, 0, 1, alpha_step * cost_map[pos])
		draw_colored_polygon(pos_to_corners(pos), color)


func update_params(costs: Dictionary, distance: int):
	cost_map = costs
	alpha_step = 1.0 / (distance * 2)
	update()

