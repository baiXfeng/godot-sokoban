extends RefCounted
class_name level_grid2d

var _data: Array
var _size: Vector2

signal on_clear
signal on_resized
signal on_data_copy
signal on_set_tile
signal on_batch_set_tile

func _init(grid_size: Vector2 = Vector2.ZERO):
	_data = []
	resize(grid_size)
	
func resize(grid_size: Vector2):
	_size = grid_size
	if grid_size != Vector2.ZERO:
		_data.resize(_size.x * _size.y)
		_data.fill(null)
	emit_signal("on_resized", self, grid_size)
	
func get_tile(pos: Vector2):
	if _is_valid(pos):
		return _data[pos.y * _size.x + pos.x]
	return null
	
func set_tile(pos: Vector2, tile):
	_set_value(pos, tile)
	emit_signal("on_set_tile", self, pos, tile)
	
func batch_set_tile(tile_list: Array):
	for item in tile_list:
		var cell: Vector2 = item[0]
		var tile = item[1]
		_set_value(cell, tile)
	emit_signal("on_batch_set_tile", self, tile_list)
	
func size():
	return _size
	
func has(pos: Vector2) -> bool:
	return _is_valid(pos)
	
func has_tile(pos: Vector2) -> bool:
	return get_tile(pos) != null
	
func clear():
	_data.clear()
	_size = Vector2.ZERO
	emit_signal("on_clear", self)
	
func copy_from(grid, deep: bool = false):
	_data = grid._data.duplicate(deep)
	_size = Vector2(grid._size.x, grid._size.y)
	emit_signal("on_data_copy", self)
	
func paste_to(grid):
	grid.copy_from(self)
	
func _set_value(pos: Vector2, value):
	if _is_valid(pos):
		_data[pos.y * _size.x + pos.x] = value
	
func _is_valid(pos: Vector2) -> bool:
	if pos.x < 0 or pos.x >= _size.x or pos.y < 0 or pos.y >= _size.y:
		return false
	return true
	
func debug_print():
	var line: String
	for y in _size.y:
		line = ""
		for x in _size.x:
			line += "%s" % get_tile(Vector2(x, y))
			line += ", " if x + 1 < _size.x else ""
		print(line)
	print("")
	
