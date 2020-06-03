extends Node

class_name Modifier

enum Types {
	PREFIX,
	SUFFIX
}

var _id:String
var affix:String
var tooltip:String
var type:int
var values:Array
var data # escape hatch for now, if none of the above are valid

func _ready():
	pass

func _init(m:Dictionary):
	_id = m._id
	affix = m.affix
	tooltip = m.tooltip # TODO: format properly based on values
	type = Types.PREFIX if m.type == "prefix" else Types.SUFFIX
	values = m.values
	pass

func prints():
	return "%s" % affix
