extends Node

class_name Modifier

enum Types {
	PREFIX,
	SUFFIX
}

var _id:String
var affix:String
var tooltip:String
var stat_line:String
var type:int
var values:Array
var data # escape hatch for now, if none of the above are valid

func _ready():
	pass

func _init(m:Dictionary):
	_id = m._id
	affix = m.affix
	type = Types.PREFIX if m.type == "prefix" else Types.SUFFIX
	values = roll_values(m.values)
	stat_line = m.stat_line
	tooltip = m.tooltip
	data = m.data if m.has("data") else ""

func roll_values(v:Array):
	var ret = v.duplicate(true)
	for val in ret:
		val["value"] = Math.roll(val.min, val.max)
	return ret

func get_stat_line():
	var vals = []
	for val in values:
		vals.push_back(val.value)
	return stat_line % vals

func get_tooltip():
	var vals = []
	for val in values:
		vals.push_back(val.min)
		vals.push_back(val.max)
	return tooltip % vals

func to_string(verbose:bool = false):
	if(verbose):
		var t = "Prefix" if type == Types.PREFIX else "Suffix"
		return "%s (%s Mod \"%s\")" % [get_stat_line(), t, affix]
	return "%s" % get_stat_line()
