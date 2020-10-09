extends Node

const SAVEDATA_PATH = "user://SAVEDATA"

var player_data = {
	"level": 1
}

func _ready():
	pass

"""
saves data to disk
"""
func save_game(): 
	var save_game = File.new()
	save_game.open(SAVEDATA_PATH, File.WRITE)
	var save_dict = {}
	save_dict.player_data = player_data
	save_game.store_line(to_json(save_dict))
	save_game.close()
	pass

"""
loads save data from disk and restores it

check_only -- if true, don't restore data
"""
func load_game(check_only=false):
	var save_game = File.new()
	
	if not save_game.file_exists(SAVEDATA_PATH):
		return false
	
	save_game.open(SAVEDATA_PATH, File.READ)
	
	var save_dict = parse_json(save_game.get_line())
	if typeof(save_dict) != TYPE_DICTIONARY:
		return false
	if not check_only:
		_restore_data(save_dict)
	
	save_game.close()
	return true

"""
restores data from the JSON dictionary inside the save files
"""
func _restore_data(save_dict):
	player_data = save_dict.player_data
	pass
	
