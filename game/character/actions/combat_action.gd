extends Node

class_name CombatAction

var initialized = false

# Since Actions can be instanced by code (ie skills) these
# actions doesn't have an owner, that's why we get the owner
# from it's parent
onready var actor: Character = get_parent().get_owner()
onready var room: Layout

export (Texture) var icon
export (String) var description: String = "Base combat action"
export var aoe: int = 1
export var shape: int = Layout.ActShape.SQUARE


func initialize(character: Character) -> void:
	actor = character
	initialized = true


func prepare():
	assert(initialized)
	print("%s missing overwrite of the prepare method" % name)
	return false


func valid_target(target: Character):
	assert(initialized)
	print("%s missing overwrite of the valid_target method" % name)
	return false


func execute(targets: Array):
	assert(initialized)
	print("%s missing overwrite of the execute method" % name)
	return false


func return_to_start_position():
	print("returned to start")
	# yield(actor.skin.return_to_start(), "completed")


func can_use() -> bool:
	return true
