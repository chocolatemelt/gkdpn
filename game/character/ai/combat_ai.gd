extends Resource

class_name CombatAI

var _game
var _actor
var _room

func initialize(actor: Character):
	_actor = actor
	_room = actor.room
	_game = actor.get_node("/root/Game")


func check_attack():
	var costs = _actor.get_attack().get_act_shape()
	var targets = _room.get_party_in_pos_list(costs.keys(), true)
	if targets.empty():
		return null
	return targets[targets.keys()[0]]


func check_move():
	pass


func enact_turn():
	var attack_target = check_attack()
	if attack_target:
		print('AI attack: ', attack_target.display_name)
		_actor.get_attack().execute([attack_target])
	_game.turn_queue.next_turn()
