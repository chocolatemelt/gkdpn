extends Area2D

const TILE_SIZE = 64 # tile height, not tile width
var inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
}
onready var ray = $RayCast2D

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE / 2)


func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var move = cartesian_to_isometric(inputs[dir] * TILE_SIZE)
	ray.cast_to = move
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += move
