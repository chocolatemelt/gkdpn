extends Node

var prng = RandomNumberGenerator.new()

func _ready():
	prng.randomize()

func roll(begin:int = 1, end:int = 6):
	return prng.randi_range(begin, end)
