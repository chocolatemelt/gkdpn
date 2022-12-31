extends BasicAttack


class_name SkillAttack


export (SpriteFrames) var cut_in
onready var cut_in_node = get_node('/root/Game/FX/CutIn')


func execute(targets: Array):
	if cut_in:
		cut_in_node.play_cut_in(cut_in, actor.position)
	.execute(targets)
