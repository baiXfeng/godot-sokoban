extends RefCounted
class_name level_data

var _data: Array[String]

func add_line(s: String):
	_data.append(s.replace("\t", "    "))
	
func debug_print():
	for s in _data:
		print(s)
	
func get_grid() -> level_grid2d:
	var grid = level_grid2d.new()
	var size = _get_map_size()
	
	var FLOOR: int = level_const.Floor.unicode_at(0)
	var BOX: int = level_const.Box.unicode_at(0)
	var WALL: int = level_const.Wall.unicode_at(0)
	var GOAL: int = level_const.Goal.unicode_at(0)
	var PLAYER: int = level_const.Player.unicode_at(0)
	var PLAYER_1: int = level_const.Player1.unicode_at(0)
	var Tab: int = level_const.Tab.unicode_at(0)
	
	grid.resize(size)
	for y in size.y:
		for x in size.x:
			var line = _data[y]
			if x >= line.length():
				grid.set_tile(Vector2(x, y), level_const.Tile.FLOOR)
				continue
			var tile: int
			match line.unicode_at(x):
				FLOOR:
					tile = level_const.Tile.FLOOR
				BOX:
					tile = level_const.Tile.BOX
				WALL:
					tile = level_const.Tile.WALL
				GOAL:
					tile = level_const.Tile.GOAL
				PLAYER:
					tile = level_const.Tile.PLAYER
				PLAYER_1:
					tile = level_const.Tile.PLAYER
				_:
					tile = level_const.Tile.FLOOR
			grid.set_tile(Vector2(x, y), tile)
	return grid
	
func _get_map_size() -> Vector2:
	var x: int
	for y in _data.size():
		if x < _data[y].length():
			x = _data[y].length()
	return Vector2(x, _data.size())
	
