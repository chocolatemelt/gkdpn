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

var title: String
var type: int
var implicit
var explicit
var flavor: String

func _ready():
	var this = Item

func _init(t, ty, f):
	title = t
	type = ty
	flavor = f

static func generate_name():
	return "(MSNAME_RANDOM_ITEM)"

static func generate_item():
	var title:String = generate_name()
	var type:int = Math.roll(0,5)
	var implicit
	var explicit
	var flavor:String = "(MSNAME_FLAVOR)"
	var new_item:Item = Item.new(title, type, flavor)
