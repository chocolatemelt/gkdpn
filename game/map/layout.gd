class_name Layout
extends TileMap

signal movement_done

var idx_to_pos: Dictionary = {}
var pos_to_idx: Dictionary = {}
var pos_count: int = 0
var origin: int = 0
var target: int = 0
var prepared_character: Character
var prepared_path: PoolIntArray

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
# move anim speed in pixel/s
const ANIM_SPEED = 250

onready var dijkstra: DijkstraMap = DijkstraMap.new()
onready var nav_draw: Node2D = $NavDraw
onready var cell_offset: Vector2 = Vector2(0, cell_size.y / 2)


func _ready():
	setup_pathfinding()
	set_physics_process(false)


func world_update_origin(player: Character, position: Vector2):
	var pos = world_to_map(position)
	if pos_to_idx.has(pos):
		update_origin(player, pos)


func world_update_target(position: Vector2):
	var pos = world_to_map(position)
	if pos_to_idx.has(pos):
		update_target(pos)


func get_spawn_tiles():
	return get_used_cells_by_id(tile_set.spawn_tile_id)


func spawn(player: Character, pos: Vector2):
	update_origin(player, pos)
	player.get_node("CamFollow").position -= player.position


func pos_to_world(pos: Vector2) -> Vector2:
	return map_to_world(pos) + cell_offset


func idx_to_world(idx: int) -> Vector2:
	return pos_to_world(idx_to_pos[idx])


func update_origin(player: Character, pos: Vector2):
	if is_physics_processing():
		return
	origin = pos_to_idx[pos]
	dijkstra.recalculate(origin, {
		'maximum_cost': player.stats.movement,
		'terrain_weights': tile_set.terrain_weights
	})
	# draw nav area
	nav_draw.update_params(dijkstra.get_cost_map(), player.stats.movement)
	prepared_character = player
	player.position = pos_to_world(pos)


func update_target(pos: Vector2):
	if is_physics_processing():
		return
	target = pos_to_idx[pos]
	var path = dijkstra.get_shortest_path_from_point(target)
	path.invert()
	path.push_back(target)
	nav_draw.path = path
	prepared_path = path
	return


func move_character():
	if prepared_path.size() > 1:
		set_physics_process(true)


func _physics_process(delta):
	if prepared_path.size() > 0:
		if move_to(pos_to_world(idx_to_pos[prepared_path[0]]), delta):
			prepared_path.remove(0)
	else:
		set_physics_process(false)
		world_update_origin(prepared_character, prepared_character.position)
		emit_signal("movement_done")


func move_to(target: Vector2, delta: float) -> bool:
	var distance: float = prepared_character.position.distance_to(target)
	if distance > 10:
		prepared_character.position = prepared_character.position.linear_interpolate(
			target, (ANIM_SPEED * delta)/distance
		)
		return false
	else:
		prepared_character.position = target
		return true

func setup_pathfinding():
	dijkstra.clear()
	var pos_idx = 0
	# add points
	for terrain_id in tile_set.get_tiles_ids():
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
