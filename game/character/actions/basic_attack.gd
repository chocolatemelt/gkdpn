extends CombatAction


func prepare():
	actor.room.draw_act_shape(actor.position, shape, aoe)


func valid_target(target: Character):
	print('valid_target?')
	print(target)
	if not target:
		print('target is null, not valid')
		return false
	if target.party_member:
		print('cant attack party member')
		return false
	return true


func execute(targets: Array):
	print(targets)
	var act_scope = actor.get_attack_scope()
	act_scope.apply_mod(Mod.new(-2, 10.0, 'basic_attack'))
	for target in targets:
		target.take_damage(act_scope)


func get_act_shape():
	return actor.room.get_act_shape(actor.position, shape, aoe)
