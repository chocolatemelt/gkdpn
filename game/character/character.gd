extends Area2D

class_name Character

signal died(character)


onready var actions = $Actions
onready var inline_outline = load('res://game/materials/inline_outline.tres')

var room: Node2D

var selected: bool = false setget set_selected
var selectable: bool = false setget set_selectable

var can_move: bool = true
var can_attack: bool = true

var prepared_attack: Node

export var display_name: String
export var stats: Resource
export var combat_ai: Resource
export var party_member = false
export var turn_order_icon: Texture


func _ready() -> void:
	selectable = true


func initialize():
	for action in actions.get_children():
		action.initialize(self)
	stats = stats.copy()
	stats.connect("life_depleted", self, "_on_life_depleted")
	room = get_parent().get_parent()
	if combat_ai:
		combat_ai.initialize(self)

func face_cursor_position(cursor_position: Vector2):
	$AnimatedSprite.set_flip_h(cursor_position.x < position.x)

func alive() -> bool:
	# Returns true if the character can perform an action
	return stats.life > 0

func get_attack_scope() -> Scope:
	var scope = Scope.new()
	var atk_mod = Mod.new(-1, stats.attack_damage, 'stats.attack_damage')
	scope.apply_mod(atk_mod)
	return scope

func get_defense_scope() -> Scope:
	var scope = Scope.new()
	scope.apply_mod(Mod.new(-1, stats.defense, 'stats.defense'))
	return scope

func get_basic_attack() -> Node:
	return get_node("Actions/BasicAttack")

func get_skill_attack() -> Node:
	return get_node("Actions/SkillAttack")

func set_selected(value):
	selected = value

func set_selectable(value):
	selectable = value
	if not selectable:
		set_selected(false)


func take_damage(received: Scope):
	var amount = received.evaluate_upon(get_defense_scope())
	stats.take_damage(amount)
	# prevent playing both stagger and death animation if life <= 0
	# if stats.life > 0:
	# 	skin.play_stagger()


func _on_life_depleted():
	selectable = false
	# yield(skin.play_death(), "completed")
	emit_signal("died", self)


func turn_start():
	can_move = true
	can_attack = true
	$AnimatedSprite.material = inline_outline


func turn_end():
	$AnimatedSprite.material = null
