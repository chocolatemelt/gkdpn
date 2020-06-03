extends Node

var prng = RandomNumberGenerator.new()

func _ready():
	pass
	
func _init():
	prng.randomize()

func roll(begin:int = 1, end:int = 6):
	return prng.randi_range(begin, end)

func sample(a:Array, n:int = 1):
	var set = a.duplicate()
	var sample = []
	for i in range(n):
		var idx = prng.randi() % set.size()
		sample.append(set[idx])
		set.remove(idx)
	return sample
