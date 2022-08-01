extends PanelContainer

onready var name_label = $Column/Name
onready var life_label = $Column/Life
onready var mana_label = $Column/Mana

var _active: Character = null
var current_life_value: int = 0
var current_mana_value: int = 0


func set_character(character: Character) -> void:
	if character != _active:
		if _active:
			_active.stats.disconnect("life_changed", self, "_on_life_changed")
			_active.stats.disconnect("mana_changed", self, "_on_mana_changed")
		character.stats.connect("life_changed", self, "_on_life_changed")
		character.stats.connect("mana_changed", self, "_on_mana_changed")

		_active = character
		current_life_value = _active.stats.life
		current_mana_value = _active.stats.mana
		name_label.set_text(_active.display_name)
		life_label.set_text("Life: %s/%s" % [current_life_value, _active.stats.max_life])
		mana_label.set_text("Mana: %s/%s" % [current_mana_value, _active.stats.max_mana])


func _on_life_changed(new, old) -> void:
	current_life_value = new
	life_label.set_text("Life: %s/%s" % [current_life_value, _active.stats.max_life])


func _on_mana_changed(new, old) -> void:
	current_mana_value = new
	mana_label.set_text("Mana: %s/%s" % [current_mana_value, _active.stats.max_mana])
