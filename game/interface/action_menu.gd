extends HBoxContainer

class_name ActionMenu

onready var _game = get_parent().get_parent()
onready var _attack = $Attack
onready var _skill = $Skill
onready var _move = $Move
onready var _pass = $Pass


func set_disabled(state):
	# state xor can_attack/move
	_attack.set_disabled(state or not _game.turn_queue.active_character.can_attack)
	_skill.set_disabled(state or not _game.turn_queue.active_character.can_attack)
	_move.set_disabled(state or not _game.turn_queue.active_character.can_move)
	_pass.set_disabled(state)

func _on_Move_toggled(button_pressed: bool):
	if button_pressed:
		_attack.set_pressed(false)
		_skill.set_pressed(false)
		_game.current_act = _game.ActState.MOVE
	else:
		_game.current_act = _game.ActState.NONE


func _on_movement_done():
	_game.turn_queue.active_character.can_move = false
	set_disabled(false)
	_game.current_act = _game.ActState.NONE
	if not _game.turn_queue.active_character.can_move and not _game.turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_combat_action(button_pressed: bool, action: CombatAction):
	if button_pressed:
		_move.set_pressed(false)
		_game.current_act = _game.ActState.ATTACK
	else:
		_game.current_act = _game.ActState.NONE
	action.prepare()


func _on_Attack_toggled(button_pressed: bool):
	if button_pressed:
		_skill.set_disabled(true)
	else:
		_skill.set_disabled(not _game.turn_queue.active_character.can_attack)
	_on_combat_action(button_pressed, _game.turn_queue.active_character.get_basic_attack())


func _on_Skill_toggled(button_pressed: bool):
	if button_pressed:
		_attack.set_disabled(true)
	else:
		_attack.set_disabled(not _game.turn_queue.active_character.can_attack)
	_on_combat_action(button_pressed, _game.turn_queue.active_character.get_skill_attack())


func _on_Attack_done():
	# allow only attack OR skill in a turn
	_game.turn_queue.active_character.can_attack = false
	_attack.set_disabled(true)
	_skill.set_disabled(true)
	_game.current_act = _game.ActState.NONE
	if not _game.turn_queue.active_character.can_move and not _game.turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_Pass_pressed():
	_game.turn_queue.next_turn()
	_move.set_disabled(false)
	_attack.set_disabled(false)
	_skill.set_disabled(false)
	_move.set_pressed(false)
	_attack.set_pressed(false)
	_skill.set_pressed(false)
	_pass.set_disabled(false)
