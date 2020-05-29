extends Node

class_name Item

enum {
	HELMET,
	CHEST,
	WEAPON,
	GLOVES,
	BOOTS,
	ACCESSORY,
}
	
func _ready():
	var this = Item
	var title
	var type
	var implicit
	var explicit
	var flavor
	
