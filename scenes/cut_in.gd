extends Node2D

const BANNER_F = 11
const BANNER_V = 15

var _drawing_banner = BANNER_F + 1
onready var _anim = $AnimatedSprite

func _draw():
	if _drawing_banner < 11:
		var height: int = _drawing_banner * BANNER_V
		var rect_y: int = _anim.position.y - height/2
		var rect: Rect2 = Rect2(0, rect_y, 960, height)
		print(rect)
		draw_rect(rect, Color(0, 0, 0), true)
		_drawing_banner += 1


func _process(delta):
	if _drawing_banner < BANNER_F:
		update()
	elif _drawing_banner == BANNER_F:
		_anim.play()


func play_cut_in(cut_in: SpriteFrames, chara_pos: Vector2):
	print(cut_in)
	_anim.frame = 0
	_anim.position = chara_pos
	_anim.frames = cut_in
	_drawing_banner = 1
	visible = true


func _on_AnimatedSprite_animation_finished():
	visible = false
