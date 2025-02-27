extends MVCProxy
class_name MVCLevel
	
var _level_map: Dictionary
var _level_max: int
	
func get_level(number: int) -> LevelGrid2d:
	if not _level_map.has(number):
		return null
	return _level_map[number].get_grid()
	
func debug_print_LevelData(number: int):
	if not _level_map.has(number):
		return null
	_level_map[number].debug_print()
	
func get_level_max() -> int:
	return _level_max
	
# =============================================================================
# private
func _init(path: String):
	var f = FileAccess.open(path, FileAccess.READ)
	if f == null:
		return
	var index: int = 0
	while not f.eof_reached():
		var line = f.get_line()
		if line.find("#") != -1:
			# 关卡开始
			var data = LevelData.new()
			index += 1
			while true:
				data.add_line(line)
				line = f.get_line()
				if line.begins_with("Title"):
					break
			_level_map[index] = data
			#data.debug_print()
	_level_max = index
