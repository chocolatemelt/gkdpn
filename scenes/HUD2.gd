extends CanvasLayer


#func _input(event):
#	if event is InputEventMouseMotion:
#		var adjusted_pos = $"../Layout".adjust_mouse_position(event.position)
#		$XY/World.set_text(str("World: ", adjusted_pos))
#		var tile_pos = $"../Layout".world_to_map(adjusted_pos)
#		if $"../Layout".pos_to_idx.has(tile_pos):
#			$XY/Tile.set_text(str("Tile: ", tile_pos, " [", $"../Layout".pos_to_idx[tile_pos], "]"))
#		else:
#			$XY/Tile.set_text(str("Tile: ", tile_pos))
