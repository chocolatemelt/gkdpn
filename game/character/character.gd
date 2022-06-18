extends Area2D

class_name Character

signal died(character)


export var stats: Resource
onready var actions = $Actions
onready var skills = $Skills
onready var ai = $AI

var target_global_position: Vector2

var selected: bool = false setget set_selected
var selectable: bool = false setget set_selectable
var display_name: String

export var party_member = false
export var turn_order_icon: Texture


func _ready() -> void:
	selectable = true
	print(stats.max_life)
	

func initialize():
	actions.initialize(skills.get_children())
	stats = stats.copy()
	stats.connect("life_depleted", self, "_on_life_depleted")


func is_able_to_play() -> bool:
	# Returns true if the character can perform an action
	return stats.life > 0


func set_selected(value):
	selected = value


func set_selectable(value):
	selectable = value
	if not selectable:
		set_selected(false)


func take_damage(hit):
	stats.take_damage(hit)
	# prevent playing both stagger and death animation if life <= 0
	# if stats.life > 0:
	# 	skin.play_stagger()


func _on_life_depleted():
	selectable = false
	# yield(skin.play_death(), "completed")
	emit_signal("died", self)

