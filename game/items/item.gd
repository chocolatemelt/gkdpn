extends Node

class_name Item

enum Types {
	HELMET,
	CHEST,
	WEAPON,
	GLOVES,
	BOOTS,
	ACCESSORY,
}

var title:String
var type:int
var implicit:Modifier
var explicit:Array
var flavor:String

func _ready():
	pass

func _init(t, ty, f, i, e=[]):
	title = t
	type = ty
	flavor = f
	implicit = i
	explicit = e

func print(verbose:bool = false):
	print(title)
	print("---")
	print("slot %d" % type)
	if(implicit != null):
		print("implicit mod %s" % implicit.to_string(verbose))
	for mod in explicit:
		print("explicit mod %s" % mod.to_string(verbose))
	print(flavor)

static func generate_name():
	return "(MSNAME_RANDOM_ITEM)"
