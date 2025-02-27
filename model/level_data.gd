extends RefCounted
class_name LevelData

var _data: Array[String]

func add_line(s: String):
	_data.append(s.replace("\t", "    "))
	
func debug_print():
	for s in _data:
		print(s)
	
func get_grid() -> LevelGrid2d:
	var grid = LevelGrid2d.new()
	var size = _get_map_size()
	
	var FLOOR: int = LevelConst.Floor.unicode_at(0)
	var BOX: int = LevelConst.Box.unicode_at(0)
	var WALL: int = LevelConst.Wall.unicode_at(0)
	var GOAL: int = LevelConst.Goal.unicode_at(0)
	var PLAYER: int = LevelConst.Player.unicode_at(0)
	var PLAYER_1: int = LevelConst.Player1.unicode_at(0)
	var Tab: int = LevelConst.Tab.unicode_at(0)
	
	grid.resize(size)
	for y in size.y:
		for x in size.x:
			var line = _data[y]
			if x >= line.length():
				grid.set_tile(Vector2(x, y), LevelConst.Tile.FLOOR)
				continue
			var tile: int
			match line.unicode_at(x):
				FLOOR:
					tile = LevelConst.Tile.FLOOR
				BOX:
					tile = LevelConst.Tile.BOX
				WALL:
					tile = LevelConst.Tile.WALL
				GOAL:
					tile = LevelConst.Tile.GOAL
				PLAYER:
					tile = LevelConst.Tile.PLAYER
				PLAYER_1:
					tile = LevelConst.Tile.PLAYER
				_:
					tile = LevelConst.Tile.FLOOR
			grid.set_tile(Vector2(x, y), tile)
	return grid
	
func _get_map_size() -> Vector2:
	var x: int
	for y in _data.size():
		if x < _data[y].length():
			x = _data[y].length()
	return Vector2(x, _data.size())
	
