# Collection of modifiers
class_name Scope

var constant_mult: float = 1.0
var modifiers: Dictionary

func _init(constant_mult: float = 1.0) -> void:
	constant_mult = constant_mult
	modifiers = {}

func apply_mod(mod: Mod) -> void:
	if not modifiers.has(mod.group):
		modifiers[mod.group] = 0.0
	modifiers[mod.group] = mod.value + modifiers[mod.group]
	print(modifiers)

func evaluate() -> float:
	var value = constant_mult
	for mod in modifiers.values():
		value *= mod
	if not value:
		return constant_mult
	return value

func evaluate_upon(defending: Scope) -> float:
	return evaluate() / defending.evaluate()
