extends Node2D


var rooms: Array = []
var characters: Array = []


var current_room: Layout
var current_character: Character
var current_camera: Camera2D setget ,_get_current_camera

func _ready():
	var dir = Directory.new()
	var rooms_dir = "res://game/map/rooms"
	if dir.open(rooms_dir) == OK:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				# break the while loop when get_next() returns ""
				break
			elif !dir.current_is_dir() and file_name.ends_with(".tscn"):
				rooms.append(rooms_dir + "/" + file_name)
		dir.list_dir_end()
	rooms.sort()

	# put characters under some folder later
	var character_resource = load("res://game/character/default_character.tscn")
	characters.append(character_resource.instance())
	switch_to_room(0)


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode - KEY_0 <= rooms.size():
			switch_to_room(event.scancode - KEY_0 - 1)

	if event is InputEventMouseButton and event.pressed:
		var adj_position = adjust_mouse_position(event.position)
		if event.button_index == BUTTON_LEFT:
			current_room.mouse_update_origin(current_character, adj_position)
		elif event.button_index == BUTTON_RIGHT:
			current_room.mouse_update_target(adj_position)


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


func adjust_mouse_position(position: Vector2):
	return position + _get_current_camera().position


func switch_to_room(idx: int):
	print("room ", idx)
	if idx < rooms.size():
		var room = get_node("Layout")
		if room:
			for character in characters:
				room.remove_child(character)
			remove_child(room)
			room.call_deferred("free")

		var room_resource = load(rooms[idx])
		current_room = room_resource.instance()
		add_child(current_room)

		for idx in characters.size():
			var character = characters[idx]
			current_room.add_child(character)
			current_room.spawn(character, current_room.get_used_cells_by_id(0)[idx])
		current_character = characters[0]

