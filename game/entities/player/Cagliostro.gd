extends Area2D

var anim_speed = 248 # travel speed in pixel/s
var per_turn_distance = 64 * 6 # max distance chara can reach at once
var cur_turn_distance = per_turn_distance
var close_enough = 16 # distance threshold to skip interpolate

var path : PoolVector2Array
onready var nav : Navigation2D = $"../FreeNav"
onready var dungeon : Node2D = $".."
onready var move_line : Line2D = $"../MoveLine"
onready var move_range : Polygon2D = $"../MoveRange"

func _ready():
	# fake drag on center positioning
	$CamFollow.position -= position
	update_move_range()


func _input(event):
#	if event is InputEventMouseMotion:
#		path = nav.get_simple_path(
#			position,
#			event.position + dungeon.cam_current.get_camera_position(),
#			false
#		)
#		path = can_move_to(path)
#		move_line.points = PoolVector2Array(path)
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if path:
				set_physics_process(true)
			if not is_physics_processing():
				path = nav.get_simple_path(
					position,
					event.position + dungeon.cam_current.get_camera_position(),
					true
				)
				path = can_move_to(path) 
				move_line.points = PoolVector2Array(path)


func _physics_process(delta):
	if path.size() > 0:
		if move_to(path[0], delta):
			path.remove(0)
	else:
		set_physics_process(false)
		update_move_range()


func iso_to_cart(pos: Vector2) -> Vector2:
	# convert isometric to cartesian distance
	return Vector2(pos.x, pos.y * 2)


func cart_to_iso(pos: Vector2) -> Vector2:
	# convert cartesian to isometric distance
	return Vector2(pos.x, pos.y / 2)


func can_move_to(path: PoolVector2Array):
	if path.size() < 2:
		return path
	var prev = iso_to_cart(path[0])
	var curr = null
	var i = 1
	var delta_d = 0
	var max_d = per_turn_distance
	while i < path.size():
		curr = iso_to_cart(path[i])
		delta_d = prev.distance_to(curr)
		if max_d < delta_d:
			if delta_d > close_enough:
				path.resize(i)
				path.append(cart_to_iso(prev.linear_interpolate(curr, max_d / delta_d)))
			return path
		max_d -= delta_d
		i += 1
		prev = curr
	return path


func move_to(target: Vector2, delta: float) -> bool:
	# move player to target
	var distance: float = position.distance_to(target)
	var complete = false
	if distance > close_enough:
		var new_position = position.linear_interpolate(
			target, (anim_speed * delta) / distance
		)
		cur_turn_distance -= iso_to_cart(position).distance_to(iso_to_cart(new_position))
		position = new_position
	else:
		position = target
		complete = true
	update_move_range()
	return complete


func update_move_range():
	if cur_turn_distance < 0:
		cur_turn_distance = per_turn_distance
	move_range.polygon = PoolVector2Array(
		[
			Vector2(position.x + cur_turn_distance, position.y),
			Vector2(position.x, position.y - cur_turn_distance / 2),
			Vector2(position.x - cur_turn_distance, position.y),
			Vector2(position.x, position.y + cur_turn_distance / 2)
		]
	)
