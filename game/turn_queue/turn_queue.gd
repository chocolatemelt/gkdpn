extends HBoxContainer


class_name TurnQueue

var _characters: Array
var _active: int
var active_character: Character setget ,_get_active
var turn_icons: Array = []

func setup(characters: Array, active: int=0):
	for prev_icon in turn_icons:
		# may need to type check here?
		remove_child(prev_icon)
		prev_icon.call_deferred("free")
	turn_icons = []
	_characters = characters
	_active = active
	for chara in _characters:
		var turn_icon = TextureRect.new()
		turn_icon.texture = chara.turn_order_icon
		turn_icon
		add_child(turn_icon)
		turn_icons.append(turn_icon)
	_update()

# func play_turn():
#	yield(_get_active().play_turn(), "completed")

func next_turn():
	move_child(turn_icons[_active], _characters.size()-1)
	_active = (_active + 1) % _characters.size()
	_update()

func _update():
	var active_chara = _get_active()
	active_chara.turn_start()
	$"/root/Game".current_room.world_update_origin(active_chara, active_chara.position)
	print($"../CharacterInfo")
	$"../CharacterInfo".set_character(active_chara)

func _get_active():
	return _characters[_active]
