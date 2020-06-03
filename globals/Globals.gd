extends Node

func _ready():
	roll_mod("armour")
	pass

static func generate_item():
	var title = Item.generate_name()
	var type = Math.roll(0,5)
	var implicit
	var explicit
	var flavor:String = "(MSNAME_FLAVOR)"
	return Item.new(title, type, flavor, implicit, explicit)

static func roll_mod(item_type:String):
	var mods_available = Data.WeightKeys[item_type]
	var mods_rolled = Math.sample(mods_available)
