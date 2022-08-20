extends Node2D


var rooms: Array
var party: Array = []


var current_room: Layout = null
var current_camera: Camera2D setget ,_get_current_camera

enum ActState {NONE, MOVE, ATTACK}
var current_act = ActState.NONE setget _set_current_act

onready var turn_queue: TurnQueue = $Overlay/TurnQueue

func _ready():
	rooms = _get_resources("res://game/map/rooms", ".tscn")
	for idx in range(rooms.size()):
		$Overlay/Debug/Map/MapSelect.add_item(rooms[idx].rsplit("/", false, 1)[1].split(".", true, 1)[0])

	for character_path in _get_resources("res://game/character/units", ".tscn"):
		var character_resource = load(character_path)
		party.append(character_resource.instance())

	switch_to_room(1)
	current_room.nav_draw.visible = false
	current_room.act_draw.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		var adj_position = adjust_mouse_position(event.position)
		if current_act == ActState.MOVE:
			current_room.world_update_target(adj_position)
		elif current_act == ActState.ATTACK:
			current_room.draw_act_target(adj_position)

	if event is InputEventMouseButton and event.pressed:
		var adj_position = adjust_mouse_position(event.position)
		if event.button_index == BUTTON_LEFT:
			if current_act == ActState.MOVE:
				current_room.move_character()
			if current_act == ActState.ATTACK:
				var basic_attack = turn_queue.active_character.get_node("Actions/BasicAttack")
				var act_target = current_room.get_act_target_character()
				if basic_attack.valid_target(act_target):
					basic_attack.execute([act_target])
					_on_Attack_done()


func _get_current_camera():
	if current_camera and current_camera.current:
		return current_camera
	else:
		# dumb workaround to get current camera in 2D context
		var viewport = get_viewport()
		if not viewport:
			return null
		var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
		var cameras = get_tree().get_nodes_in_group(camerasGroupName)
		for camera in cameras:
			if camera is Camera2D and camera.current: 
				current_camera = camera
				return camera
		return null


func _set_current_act(value):
	current_act = value
	current_room.nav_draw.visible = value == ActState.MOVE and turn_queue.active_character.can_move
	current_room.act_draw.visible = value == ActState.ATTACK and turn_queue.active_character.can_attack


func _get_resources(dir_path: String, ext: String):
	var dir = Directory.new()
	var resource_list = []
	if dir.open(dir_path) == OK:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				# break the while loop when get_next() returns ""
				break
			elif !dir.current_is_dir() and file_name.ends_with(ext):
				resource_list.append(dir_path + "/" + file_name)
		dir.list_dir_end()
		resource_list.sort()
	return resource_list


func adjust_mouse_position(position: Vector2):
	return position + _get_current_camera().position


func switch_to_room(idx: int):
	if idx < rooms.size():
		var characters: Array = []

		if current_room:
			for character in current_room.party.get_children():
				current_room.remove_child(character)
			remove_child(current_room)
			current_room.disconnect("movement_done", self, "_on_movement_done")
			current_room.call_deferred("free")

		var room_resource = load(rooms[idx])
		current_room = room_resource.instance()
		current_room.connect("movement_done", self, "_on_movement_done")
		add_child(current_room)

		var spawn_tiles = current_room.get_spawn_tiles()
		spawn_tiles.sort()
		for idx in party.size():
			var character = party[idx]
			current_room.party.add_child(character)
			character.initialize()
			character.stats.reset()
			current_room.spawn(character, spawn_tiles[idx])
			characters.append(character)

		for enemy in current_room.enemies.get_children():
			enemy.initialize()
			enemy.stats.reset()
			characters.append(enemy)

		turn_queue.setup(characters, 0)


func _on_Move_toggled(button_pressed: bool):
	if button_pressed:
		$Overlay/ActionMenu/Attack.set_pressed(false)
		_set_current_act(ActState.MOVE)
	else:
		_set_current_act(ActState.NONE)


func _on_movement_done():
	turn_queue.active_character.can_move = false
	$Overlay/ActionMenu/Move.set_disabled(true)
	_set_current_act(ActState.NONE)
	if not turn_queue.active_character.can_move and not turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_Attack_toggled(button_pressed: bool):
	if button_pressed:
		$Overlay/ActionMenu/Move.set_pressed(false)
		_set_current_act(ActState.ATTACK)
	else:
		_set_current_act(ActState.NONE)
	var basic_attack = turn_queue.active_character.get_node("Actions/BasicAttack")
	basic_attack.prepare()


func _on_Attack_done():
	turn_queue.active_character.can_attack = false
	$Overlay/ActionMenu/Attack.set_disabled(true)
	_set_current_act(ActState.NONE)
	if not turn_queue.active_character.can_move and not turn_queue.active_character.can_attack:
		_on_Pass_pressed()

func _on_Pass_pressed():
	$Overlay/ActionMenu/Move.set_disabled(false)
	$Overlay/ActionMenu/Move.set_pressed(false)
	$Overlay/ActionMenu/Attack.set_disabled(false)
	$Overlay/ActionMenu/Attack.set_pressed(false)
	turn_queue.next_turn()
