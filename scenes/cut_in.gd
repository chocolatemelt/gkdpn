extends Node2D


onready var _anim = $AnimatedSprite

func _draw():
	if _anim.playing:
		draw_rect(Rect2(0, 200, 960, 165), Color(0, 0, 0), true)

func play_cut_in(cut_in: SpriteFrames, chara_pos: Vector2):
	print(cut_in)
	_anim.frame = 0
	_anim.position = chara_pos
	_anim.frames = cut_in
	visible = true
	_anim.play()
	update()


func _on_AnimatedSprite_animation_finished():
	visible = false
	update()
