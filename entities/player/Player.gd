extends Area2D

var tile_size = 64
var inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
}

# func _ready():
	# TODO: snap to isometric grid?
	# position = position.snapped(Vector2.ONE * tile_size)


func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += cartesian_to_isometric(inputs[dir] * tile_size)
