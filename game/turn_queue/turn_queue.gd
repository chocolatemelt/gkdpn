class_name TurnQueue
extends HBoxContainer

var _characters: Array
var _active: int
var _min_speed: float
var _max_speed: float
var turn_order: PoolIntArray = PoolIntArray()
var active_character: Character setget ,_get_active
var turn_icons: Array = []

onready var _game = $"/root/Game"
onready var _chara_info = $"../CharacterInfo"

func speed_sort(a, b):
	# slowest to fastest
	return a.stats.speed > b.stats.speed


func setup(characters: Array, active: int=0):
	for prev_icon in turn_icons:
		# may need to type check here?
		remove_child(prev_icon)
		prev_icon.call_deferred("free")
	turn_icons = []
	_characters = characters
	_characters.sort_custom(self, "speed_sort")
	_active = active
	update_turn_order()
	_update()

func update_turn_order():
	_min_speed = _characters[0].stats.speed
	_max_speed = _characters[0].stats.speed
	for chara in _characters:
		_min_speed = min(_min_speed, chara.stats.speed)
		_max_speed = max(_max_speed, chara.stats.speed)

	turn_order.resize(0)
	for count in range(0, _max_speed+_min_speed, _min_speed):
		for c_idx in range(_characters.size()):
			var chara = _characters[c_idx]
			# print(chara.display_name, " ", chara.stats.speed, " ", count)
			if chara.stats.speed > count:
				continue
			turn_order.push_back(c_idx)
			var turn_icon = TextureRect.new()
			turn_icon.set_stretch_mode(TextureRect.STRETCH_SCALE)
			turn_icon.texture = chara.turn_order_icon
			turn_icon.set_custom_minimum_size(Vector2(40, 40))
			add_child(turn_icon)
			turn_icons.append(turn_icon)

func next_turn():
	_get_active().turn_end()
	move_child(turn_icons[_active], turn_order.size()-1)
	_active = (_active + 1) % turn_order.size()
	_update()

func _update():
	var active_chara = _get_active()
	active_chara.turn_start()
	_game.current_room.world_update_origin(active_chara, active_chara.position)
	_chara_info.set_character(active_chara)
	if active_chara.combat_ai:
		active_chara.combat_ai.enact_turn()

func _get_active():
	return _characters[turn_order[_active]]
