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
enum ActShape {SELF = 0, SQUARE = 1, LINE = 2}


onready var dijkstra: DijkstraMap = DijkstraMap.new()
onready var act_dijkstra: DijkstraMap = DijkstraMap.new()
onready var nav_draw: Node2D = $NavDraw
onready var act_draw: Node2D = $ActDraw
onready var wall: Wall = $Wall
onready var party: Node = $Party
onready var enemies: Node = $Enemies
onready var cell_offset: Vector2 = Vector2(0, cell_size.y / 2)


func _ready():
	setup_pathfinding()
	set_physics_process(false)
	for enemy in $Enemies.get_children():
		world_update_origin(enemy, enemy.position)


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
	dijkstra.disable_point(origin)
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


func draw_act_shape(position: Vector2, shape: int, radius: int, pathed: bool = true):
	var pos = world_to_map(position)
	var costs: Dictionary = {}

	if shape == ActShape.SELF:
		radius = 1
		costs[pos] = 1
	elif shape == ActShape.SQUARE:
		for i in range(-radius, radius+1):
			for j in range(-radius, radius+1):
				var offset_pos = pos + Vector2(i, j)
				if pos_to_idx.has(offset_pos):
					costs[offset_pos] = max(abs(i), abs(j))
	elif shape == ActShape.LINE:
		for r in range(1, radius+1):
			for dir in [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]:
				var offset_pos = pos + r * dir
				if pos_to_idx.has(offset_pos):
					costs[offset_pos] = r

	if pathed:
		for idx in idx_to_pos.keys():
			if costs.has(idx_to_pos[idx]):
				act_dijkstra.enable_point(idx)
			else:
				act_dijkstra.disable_point(idx)
		act_dijkstra.recalculate(origin, {
			'maximum_cost': float(radius),
			'terrain_weights': {-1: 1.0}
		})
		var ref_costs = act_dijkstra.get_cost_map()
		costs = {}
		for idx in ref_costs.keys():
			costs[idx_to_pos[idx]] = ref_costs[idx]


	act_draw.update_params(costs, radius)


func draw_act_target(position: Vector2):
	var pos = world_to_map(position)
	if pos_to_idx.has(pos):
		act_draw.target = pos
	else:
		act_draw.target = Vector2.INF
	act_draw.update()


func get_act_target_character():
	if act_draw.target == Vector2.INF:
		return null
	if not act_draw.cost_map.has(act_draw.target):
		return null
	for enemy in enemies.get_children():
		if world_to_map(enemy.position) == act_draw.target:
			return enemy
	for chara in party.get_children():
		if world_to_map(chara.position) == act_draw.target:
			return chara
	return null

func _physics_process(delta):
	if prepared_path.size() > 0:
		if move_to(pos_to_world(idx_to_pos[prepared_path[0]]), delta):
			dijkstra.enable_point(prepared_path[0])
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
			if wall.passable(pos, offset):
				continue
			dijkstra.connect_points(pos_to_idx[to_pos], idx, WEIGHT_CARDINAL, false)
		for offset in OFFSETS_ORDINAL:
			var to_pos = pos + offset
			if not pos_to_idx.has(to_pos):
				continue
			if wall.passable(pos, offset):
				continue
			# only allow the connection if both related cardinal direction tiles are filled
			if not pos_to_idx.has(Vector2(pos.x + offset.x, pos.y)):
				continue
			if not pos_to_idx.has(Vector2(pos.x, pos.y + offset.y)):
				continue
			dijkstra.connect_points(pos_to_idx[to_pos], idx, WEIGHT_ORDINAL, false)
	
	act_dijkstra.duplicate_graph_from(dijkstra)
	for idx in idx_to_pos.keys():
		act_dijkstra.set_terrain_for_point(idx, -1)
