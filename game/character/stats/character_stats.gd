# Represents a Character's actual stats.
extends Resource

class_name CharacterStats

signal life_changed(new_life, old_life)
signal life_depleted
signal mana_changed(new_mana, old_mana)
signal mana_depleted

var modifiers = {}

var life: int
var mana: int setget set_mana
export var max_life: int = 1 setget set_max_life, _get_max_life
export var max_mana: int = 0 setget set_max_mana, _get_max_mana
export var attack_damage: int = 1 setget , _get_attack_damage
export var spell_damage: int = 0 setget , _get_spell_damage
export var defense: int = 1 setget , _get_defense
export var speed: int = 1 setget , _get_speed
export var movement: float = 4.0 setget, _get_movement
var is_alive: bool setget , _is_alive


func reset():
	life = self.max_life
	mana = self.max_mana


func copy() -> CharacterStats:
	# Perform a more accurate duplication, as normally Resource duplication
	# does not retain any changes, instead duplicating from what's registered
	# in the ResourceLoader
	var copy = duplicate()
	copy.life = life
	copy.mana = mana
	return copy


func take_damage(amount: int):
	var old_life = life
	life -= amount
	life = max(0, life)
	print('%s damage' % (old_life - life))
	emit_signal("life_changed", life, old_life)
	if life == 0:
		emit_signal("life_depleted")


func heal(amount: int):
	var old_life = life
	life = min(life + amount, max_life)
	emit_signal("life_changed", life, old_life)


func set_mana(value: int):
	var old_mana = mana
	mana = max(0, value)
	emit_signal("mana_changed", mana, old_mana)
	if mana == 0:
		emit_signal("mana_depleted")


func set_max_life(value: int):
	if value == null:
		return
	max_life = max(1, value)


func set_max_mana(value: int):
	if value == null:
		return
	max_mana = max(0, value)


func add_modifier(id: int, modifier):
	modifiers[id] = modifier


func remove_modifier(id: int):
	modifiers.erase(id)


func _is_alive() -> bool:
	return life >= 0


func _get_max_life() -> int:
	return max_life


func _get_max_mana() -> int:
	return max_mana


func _get_attack_damage() -> int:
	return attack_damage

func _get_spell_damage() -> int:
	return spell_damage

func _get_defense() -> int:
	return defense

func _get_speed() -> int:
	return speed

func _get_movement() -> float:
	return movement
