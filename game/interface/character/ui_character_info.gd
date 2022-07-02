extends CanvasLayer

class_name UICharacterInfo

onready var name_label = $Control/InfoPanel/Column/Name
onready var life_label = $Control/InfoPanel/Column/Life
onready var mana_label = $Control/InfoPanel/Column/Mana

var character_name: String = ""
var character_stats: CharacterStats
var current_life_value: int = 0
var current_mana_value: int = 0

func _ready() -> void:
	name_label.display(character_name)
	life_label.display(current_life_value, character_stats.max_life)
	mana_label.display(current_mana_value, character_stats.max_mana)

func initialize(character: Character) -> void:
	character_stats = character.stats
	character_name = character.display_name
	current_life_value = character_stats.max_life
	current_mana_value = character_stats.max_mana
	_connect_value_signals(character)
	

func _connect_value_signals(character: Character) -> void:
	character_stats.connect("life_changed", self, "_on_life_changed")
	character_stats.connect("mana_changed", self, "_on_mana_changed")

func _on_life_changed(new, old) -> void:
	current_life_value = new

func _on_mana_changed(new, old) -> void:
	current_mana_value = new
