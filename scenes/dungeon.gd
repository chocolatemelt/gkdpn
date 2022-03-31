extends Node2D

# magical knowledge of the tile size
const SNAP_SIZE = Vector2(32, 16)

var inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
}

# travel speed in pixel/s
var speed = 250
var path : PoolVector2Array
var goal : Vector2
var camera_origin: Vector2

onready var nav : Navigation2D = $Navigation2D


func snap_to_cell(pos: Vector2) -> Vector2:
#	var space = get_node('../Navigation2D/Floors')
#	var cell = to_global(space.map_to_world(space.world_to_map(to_local(pos))))
#	return cell.snapped(Vector2.ONE * TILE_SIZE / 2)
	return pos.snapped(SNAP_SIZE)


func global_to_tile(pos: Vector2) -> Vector2:
	var layout = $Navigation2D/Layout
	return layout.to_global(
		layout.map_to_world(
			layout.world_to_map(
				layout.to_local(pos))))


func move_to(entity, target: Vector2, delta: float) -> bool:
	var distance: float = entity.position.distance_to(target)
	if distance > 10:
		entity.position = entity.position.linear_interpolate(
			target, (speed * delta)/distance
		)
		$PlayerPosition.set_text(String(entity.position))
		return false
	else:
		entity.position = target
		$PlayerPosition.set_text(String(entity.position))
		return true


func _ready():
	$Player.position = snap_to_cell($Player.position)


# TODO: avoid hitting walls?
func _input(event):
	if event is InputEventMouseMotion:
		var adjusted_pos = snap_to_cell(event.position)
		$MousePosition.set_text(String(adjusted_pos))
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
#			print($Player/Camera2D.get_camera_position() - camera_origin)
			print($Player.position, event.position)
			path = nav.get_simple_path(
				$Player.position,
				event.position,
				false
			)
			for idx in path.size():
				path[idx] = snap_to_cell(path[idx])
			$PathIndicator.points = PoolVector2Array(path)
			print(path)


func _process(delta):
	if !path:
		return
	if path.size() > 0:
		if move_to($Player, path[0], delta):
			path.remove(0)
