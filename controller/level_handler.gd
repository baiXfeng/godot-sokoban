extends mvc_handler

# override
func _on_enter(a: mvc_app):
	a.add_callable("goto_level", _goto_level)
	
# override
func _on_exit(a: mvc_app):
	a.remove_callable("goto_level", _goto_level)
	
func _goto_level(e: mvc_event):
	var level: int = e.data.level
	var level_proxy: mvc_level = app().get_proxy("level:brithday")
	
	# 合法性检查
	var level_grid = level_proxy.get_level(level)
	if level_grid == null:
		return
	level_proxy.debug_print_level_data(level)
	
	# 保留原始地图
	var source_grid: level_grid2d = app().get_proxy("source_map").data()
	source_grid.copy_from(level_grid)
	
	# 加载并显示关卡
	get_tree().change_scene_to_file("res://view/room/room.tscn")
	await get_tree().tree_changed
	
	# 初始化地板、墙壁、目标点、箱子、玩家
	var room_grid: level_grid2d = app().get_proxy("room_map").data()
	var box_grid: level_grid2d = app().get_proxy("box_map").data()
	room_grid.clear()
	room_grid.resize(level_grid.size())
	for y in level_grid.size().y:
		for x in level_grid.size().x:
			var cell = Vector2(x, y)
			if not level_grid.has_tile(cell):
				continue
			var tile: int = level_grid.get_tile(cell)
			match tile:
				level_const.Tile.FLOOR:
					room_grid.set_tile(cell, tile)
				level_const.Tile.WALL:
					room_grid.set_tile(cell, tile)
				level_const.Tile.GOAL:
					room_grid.set_tile(cell, tile)
				level_const.Tile.PLAYER:
					room_grid.set_tile(cell, level_const.Tile.FLOOR)
					var view = preload("res://view/player/player.tscn").instantiate()
					var player = app().get_proxy("player")
					player.set_data(view)
					view.position = Vector3(cell.x * 2 + 1, 0, cell.y * 2 + 1)
				level_const.Tile.BOX:
					room_grid.set_tile(cell, level_const.Tile.FLOOR)
					var view = preload("res://view/room/box.tscn").instantiate()
					box_grid.set_tile(cell, view)
					view.position = Vector3(cell.x * 2, 0, cell.y * 2)
	
