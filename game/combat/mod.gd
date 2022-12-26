# a modifier applied to a stat
class_name Mod

var name: String
var group: int
var value: float

func _init(_group: int, _value: float, _name: String = '<anon>') -> void:
	name = _name
	group = _group
	value = _value

func debug():
	print('%s[%s]: %s' % [name, group, value])
