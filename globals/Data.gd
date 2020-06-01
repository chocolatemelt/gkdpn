extends Node

var GearBases:Dictionary
var ModGear:Dictionary
var ModImplicit:Dictionary
var WeightKeys:Dictionary
var WeightValues:Dictionary

func _ready():
	var f = File.new()
	GearBases = parse_dict("GearBases", f)
	ModGear = parse_dict("ModGear", f)
	ModImplicit = parse_dict("ModImplicit", f)
	WeightKeys = parse_dict("WeightKeys", f)
	WeightValues = parse_dict("WeightValues", f)
	f.close()

func parse_dict(p:String, f:File):
	var path = "res://data/%s.json" % p
	f.open(path, f.READ)
	var res = JSON.parse(f.get_as_text())
	if(res.error != OK):
		# TODO: error handling? why does godot not have throw
		print("something went wrong parsing json, handle this better thanks")
		return {}
	if(typeof(res.result) != TYPE_DICTIONARY):
		print("json parsed but not a dictionary")
		return {}
	return res.result
