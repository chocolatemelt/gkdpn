extends KinematicBody2D

const MOTION_SPEED = 400 # px/s

var motion = Vector2()

func cartesian_to_isometric(cartesian):
	var screen_pos = Vector2()
	screen_pos.x = cartesian.x - cartesian.y
	screen_pos.y = (cartesian.x + cartesian.y) / 2
	return screen_pos

func _physics_process(_delta):
	var direction = Vector2()
	if Input.is_action_pressed("move_up"):
		direction += Vector2(0, -1)
	elif Input.is_action_pressed("move_down"):
		direction += Vector2(0, 1)
	
	if Input.is_action_pressed("move_left"):
		direction += Vector2(-1, 0)
	elif Input.is_action_pressed("move_right"):
		direction += Vector2(1, 0)

	motion = direction.normalized() * MOTION_SPEED * _delta
	motion = cartesian_to_isometric(motion)

	#warning-ignore:return_value_discarded
	move_and_slide(motion)
