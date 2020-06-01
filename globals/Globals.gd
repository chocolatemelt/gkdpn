extends Node

func _ready():
	#var test_item = generate_item()
	#test_item.print()
	pass

static func generate_item():
	var title = Item.generate_name()
	var type = Math.roll(0,5)
	var implicit
	var explicit
	var flavor:String = "(MSNAME_FLAVOR)"
	return Item.new(title, type, flavor, implicit, explicit)
