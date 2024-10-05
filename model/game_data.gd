extends mvc_proxy
class_name game_data

var _game_data: Dictionary

# 设置地图最大闯关数
func set_level_max(key: String, value: int):
	var d = _get_map_data(key)
	d["max_level"] = value
	
func get_level_max(key: String) -> int:
	var d = _get_map_data(key)
	return d["max_level"]
	
# 设置地图关卡星级
func set_level_star(key: String, level: int, star: int):
	var d = _get_map_data(key)
	var star_map = d["star_map"] as Dictionary
	star_map[level] = star
	
func get_level_star(key: String, level: int) -> int:
	var d = _get_map_data(key)
	var star_map = d["star_map"] as Dictionary
	if star_map.has(level):
		return star_map[level]
	return 0
	
func _get_map_data(key: String) -> Dictionary:
	if _game_data.has(key):
		return _game_data[key]
	_game_data[key] = {
		"max_level": 1,
		"star_map": {},
	}
	return _game_data[key]
	
# override
func _on_save(dict: Dictionary):
	dict["data"] = _game_data.duplicate()
	
# override
func _on_load(dict: Dictionary):
	if dict.has("data"):
		_game_data = dict["data"]
	
