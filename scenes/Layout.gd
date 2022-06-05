extends TileMap

var idx_to_pos: Dictionary = {}
var pos_to_idx: Dictionary = {}
var pos_count: int = 0
var origin: int = 0
var target: int = 0

# terrain, should make dynamic instead
const TERRAIN_H10: int = 0
const TERRAIN_H20: int = 1
const TERRAIN_H30: int = 2
const TERRAINS: Dictionary = {
	TERRAIN_H10: 1,
	TERRAIN_H20: 1,
	TERRAIN_H30: 1,
}

const MAX_COST: float = 4.0

const DIJKSTRA_PARAMS: Dictionary = {
	'maximum_cost': MAX_COST,
	'terrain_weights': TERRAINS
}

# directions
const OFFSETS_CARDINAL: PoolVector2Array = PoolVector2Array([
	Vector2(0, -1), # N
	Vector2(0, 1), # S
	Vector2(-1, 0), # W
	Vector2(1, 0), # E
])
const WEIGHT_CARDINAL: float = 1.0
const OFFSETS_ORDINAL: PoolVector2Array = PoolVector2Array([
	Vector2(-1, -1), # NW
	Vector2(-1, 1),  # SW
	Vector2(1, -1), # NE
	Vector2(1, 1), # SE
])
const WEIGHT_ORDINAL: float = 1.5
const TILE_SETS = [
	preload("res://entities/tiles/Stacks.tres"),
	preload("res://entities/tiles/InverseStacks.tres")
]

onready var dijkstra: DijkstraMap = DijkstraMap.new()
onready var player: Area2D = $"../Platinum"
onready var nav_draw: Node2D = $NavDraw
onready var cell_offset: Vector2 = Vector2(0, cell_size.y / 2)
onready var cams = [$"../CamStatic", $"../CamMouse"]
onready var cam_idx = 0



func _ready():
	setup_pathfinding()
	# test
	# trial()
	dijkstra.recalculate(origin, DIJKSTRA_PARAMS)
	update_origin(world_to_map(player.position))
	$"../Platinum/CamFollow".position -= player.position


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var pos = world_to_map(adjust_mouse_position(event.position))
		if pos_to_idx.has(pos):
			if event.button_index == BUTTON_LEFT:
				update_origin(pos)
			elif event.button_index == BUTTON_RIGHT:
				update_target(pos)
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			cam_idx = (cam_idx + 1) % cams.size()
			cams[cam_idx].make_current()
		if event.scancode - KEY_0 <= TILE_SETS.size():
			tile_set = TILE_SETS[event.scancode - KEY_0 - 1]


func get_height_for_idx(idx: int):
	return dijkstra.get_terrain_for_point(idx) * 10


func adjust_mouse_position(position: Vector2):
	return position + cams[cam_idx].get_camera_position()


func pos_to_world(pos: Vector2):
	return map_to_world(pos) + cell_offset


func idx_to_world(idx: int):
	return pos_to_world(idx_to_pos[idx])


func update_origin(pos: Vector2):
	origin = pos_to_idx[pos]
	dijkstra.recalculate(origin, DIJKSTRA_PARAMS)
	player.position = pos_to_world(pos)
	# draw nav area
	nav_draw.cost_map = dijkstra.get_cost_map()


func update_target(pos: Vector2):
	target = pos_to_idx[pos]
	var path = dijkstra.get_shortest_path_from_point(target)
	path.invert()
	path.push_back(target)
	nav_draw.path = path


func setup_pathfinding():
	dijkstra.clear()
	var pos_idx = 0
	# add points
	for terrain_id in TERRAINS.keys():
		for pos in get_used_cells_by_id(terrain_id):
			idx_to_pos[pos_idx] = pos
			pos_to_idx[pos] = pos_idx
			dijkstra.add_point(pos_idx, terrain_id)
			pos_idx += 1
	pos_count = pos_idx
	# connect points
	for idx in range(pos_count):
		var pos = idx_to_pos[idx]
		for offset in OFFSETS_CARDINAL:
			var to_pos = pos + offset
			if not pos_to_idx.has(to_pos):
				continue
			dijkstra.connect_points(idx, pos_to_idx[to_pos], WEIGHT_CARDINAL, true)
		for offset in OFFSETS_ORDINAL:
			var to_pos = pos + offset
			if not pos_to_idx.has(to_pos):
				continue
			# only allow the connection if both related cardinal direction tiles are filled
			if not pos_to_idx.has(Vector2(pos.x + offset.x, pos.y)):
				continue
			if not pos_to_idx.has(Vector2(pos.x, pos.y + offset.y)):
				continue
			dijkstra.connect_points(idx, pos_to_idx[to_pos], WEIGHT_ORDINAL, true)
