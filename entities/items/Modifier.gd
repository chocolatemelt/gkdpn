extends Node

class_name Modifier

var modifier:String
var title:String
var affix:bool

var value:int
var low:int
var high:int
var data # escape hatch for now, if none of the above work

func _ready():
	pass # Replace with function body.

func _init(m):
	modifier = m

func prints():
	return "%s" % modifier

static func roll_modifier():
	pass
