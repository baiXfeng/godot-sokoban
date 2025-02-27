extends MVCProxy
class_name GameData

var _GameData: Dictionary

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
	star_map[str(level)] = star
	
func get_level_star(key: String, level: int) -> int:
	var d = _get_map_data(key)
	var star_map = d["star_map"] as Dictionary
	var star_key = str(level)
	if star_map.has(star_key):
		return star_map[star_key]
	return 0
	
func _get_map_data(key: String) -> Dictionary:
	if _GameData.has(key):
		return _GameData[key]
	_GameData[key] = {
		"max_level": 1,
		"star_map": {},
	}
	return _GameData[key]
	
# override
func _on_save(dict: Dictionary):
	dict["data"] = _GameData.duplicate()
	
# override
func _on_load(dict: Dictionary):
	if dict.has("data"):
		_GameData = dict["data"]
	
