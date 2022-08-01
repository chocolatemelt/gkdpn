extends CombatAction

func prepare():
	assert(initialized)
	actor.room.draw_act_shape(actor.position, shape, aoe)


func valid_target(target: Character):
	assert(initialized)
	if not target:
		return false
	if target.party_member:
		return false
	return true


func execute(targets: Array):
	assert(initialized)
	var hit: Hit = Hit.new(10)
	for target in targets:
		target.take_damage(hit)
