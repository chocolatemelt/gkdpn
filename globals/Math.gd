extends Node

var prng = RandomNumberGenerator.new()
func _ready():
	prng.randomize()

func randf():
	return prng.randf_range(0.0, 1.0)
