extends CombatAction


func prepare():
	actor.room.draw_act_shape(actor.position, shape, aoe)


func valid_target(target: Character):
	if not target:
		return false
	if target.party_member:
		return false
	return true


func execute(targets: Array):
	var hit: Hit = Hit.new(50)
	for target in targets:
		target.take_damage(hit)


func get_act_shape():
	return actor.room.get_act_shape(actor.position, shape, aoe)
