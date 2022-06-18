extends Position2D

class_name CharacterAnim

onready var anim = $AnimationPlayer
onready var extents = $RectExtents2D


func play_stagger():
	anim.play("take_damage")
	yield(anim, "animation_finished")


func play_death():
	anim.play("death")
	yield(anim, "animation_finished")
