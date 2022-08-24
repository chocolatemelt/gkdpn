extends HBoxContainer

class_name ActionMenu

onready var _game = get_parent().get_parent()
onready var _attack = $Attack
onready var _move = $Move
onready var _pass = $Pass

func _on_Move_toggled(button_pressed: bool):
	if button_pressed:
		_attack.set_pressed(false)
		_game.current_act = _game.ActState.MOVE
	else:
		_game.current_act = _game.ActState.NONE


func _on_movement_done():
	_game.turn_queue.active_character.can_move = false
	_move.set_disabled(true)
	_game.current_act = _game.ActState.NONE
	if not _game.turn_queue.active_character.can_move and not _game.turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_Attack_toggled(button_pressed: bool):
	if button_pressed:
		_move.set_pressed(false)
		_game.current_act = _game.ActState.ATTACK
	else:
		_game.current_act = _game.ActState.NONE
	var basic_attack = _game.turn_queue.active_character.get_node("Actions/BasicAttack")
	basic_attack.prepare()


func _on_Attack_done():
	_game.turn_queue.active_character.can_attack = false
	_attack.set_disabled(true)
	_game.current_act = _game.ActState.NONE
	if not _game.turn_queue.active_character.can_move and not _game.turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_Pass_pressed():
	_move.set_disabled(false)
	_move.set_pressed(false)
	_attack.set_disabled(false)
	_attack.set_pressed(false)
	_game.turn_queue.next_turn()
