extends Node2D


var rooms: Array
var characters: Array = []


var current_room: Layout = null
var current_camera: Camera2D setget ,_get_current_camera


onready var turn_queue: TurnQueue = $Overlay/TurnQueue

func _ready():

	rooms = _get_resources("res://game/map/rooms", ".tscn")
	for idx in range(rooms.size()):
		$Overlay/Debug/Map/MapSelect.add_item(rooms[idx].rsplit("/", false, 1)[1].split(".", true, 1)[0])

	for character_path in _get_resources("res://game/character/units", ".tscn"):
		var character_resource = load(character_path)
		characters.append(character_resource.instance())

	switch_to_room(2)


func _input(event):
	if event is InputEventKey and event.pressed:
#		if event.scancode - KEY_0 <= rooms.size():
#			switch_to_room(event.scancode - KEY_0 - 1)
		if event.scancode == KEY_SPACE:
			turn_queue.play_turn()

	if event is InputEventMouseMotion:
		var adj_position = adjust_mouse_position(event.position)
		current_room.world_update_target(adj_position)

	if event is InputEventMouseButton and event.pressed:
		var adj_position = adjust_mouse_position(event.position)
#		if event.button_index == BUTTON_LEFT:
#			current_room.world_update_origin(turn_queue.active_character, adj_position)
#		elif event.button_index == BUTTON_RIGHT:
#			current_room.world_update_target(adj_position)
		if event.button_index == BUTTON_LEFT:
			current_room.move_character()


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
		if current_room:
			for character in characters:
				current_room.remove_child(character)
			remove_child(current_room)
			current_room.disconnect("movement_done", turn_queue, "next_turn")
			current_room.call_deferred("free")

		var room_resource = load(rooms[idx])
		current_room = room_resource.instance()
		current_room.connect("movement_done", turn_queue, "next_turn")
		add_child(current_room)

		var spawn_tiles = current_room.get_used_cells_by_id(0)
		spawn_tiles.sort()
		for idx in characters.size():
			var character = characters[idx]
			current_room.add_child(character)
			current_room.spawn(character, spawn_tiles[idx])
		turn_queue.setup(characters, 0)

