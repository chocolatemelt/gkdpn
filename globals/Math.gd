extends Node

var prng = RandomNumberGenerator.new()

func _ready():
	pass
	
func _init():
	prng.randomize()

func roll(begin:int = 1, end:int = 6):
	return prng.randi_range(begin, end)
