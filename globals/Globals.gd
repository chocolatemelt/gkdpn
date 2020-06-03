extends Node

func _ready():
	var emods = roll_mods("armour", 2)
	var item = Item.new(Item.generate_name(), Item.Types.HELMET, "(MSNAME_FLAVOR)", null, emods)
	item.print(true)
	pass

static func generate_item():
	var title = Item.generate_name()
	var type = Math.roll(0,5)
	var implicit
	var explicit
	var flavor:String = "(MSNAME_FLAVOR)"
	return Item.new(title, type, flavor, implicit, explicit)

static func roll_mods(item_type:String, n:int = 1):
	# at some point, collect the correct weighting here too
	var mods_available = Data.WeightKeys[item_type]
	var mods_rolled = Math.sample(mods_available, n)
	var ret = []
	for mod in mods_rolled:
		var mod_data = Math.roll_array(Data.ModGear[mod])
		ret.push_back(Modifier.new(mod_data))
	return ret
