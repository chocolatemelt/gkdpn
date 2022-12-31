extends CombatAction

class_name BasicAttack

export var mod_value: float = 10.0


func prepare():
	actor.room.draw_act_shape(actor.position, shape, aoe)
	actor.prepared_attack = self


func valid_target(target: Character):
	if not target:
		return false
	if target.party_member:
		return false
	return true


func execute(targets: Array):
	var act_scope = actor.get_attack_scope()
	act_scope.apply_mod(Mod.new(-2, mod_value, 'basic_attack'))
	for target in targets:
		target.take_damage(act_scope)


func get_act_shape():
	return actor.room.get_act_shape(actor.position, shape, aoe)
