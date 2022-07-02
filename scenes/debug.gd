extends GridContainer


func _input(event):
	if event is InputEventMouseMotion:
		var adjusted_pos = $"/root/Game".adjust_mouse_position(event.position)
		$World.set_text("W: %4d, %4d  " % [adjusted_pos.x, adjusted_pos.y])
		var current_room = $"/root/Game".current_room
		var tile_pos = current_room.world_to_map(adjusted_pos)
		if current_room.pos_to_idx.has(tile_pos):
			$Tile.set_text(str(tile_pos, " [", current_room.pos_to_idx[tile_pos], "]"))
			$Tile.set_text("T: %4d, %4d [%2d]" % [tile_pos.x, tile_pos.y, current_room.pos_to_idx[tile_pos]])
		else:
			$Tile.set_text("T: %4d, %4d [NA]" % [tile_pos.x, tile_pos.y])
