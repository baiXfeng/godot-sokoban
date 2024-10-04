extends mvc_handler

# override
func _on_enter(a: mvc_app):
	a.add_callable("switch_map", _switch_map)
	a.add_callable("goto_level", _goto_level)
	a.add_callable("exit_level", _exit_level)
	
# override
func _on_exit(a: mvc_app):
	a.remove_callable("switch_map", _switch_map)
	a.remove_callable("goto_level", _goto_level)
	a.remove_callable("exit_level", _exit_level)
	
func _switch_map(e: mvc_event):
	var name: String = e.data.name
	app().get_proxy("current_map").set_data(name)
	
func _exit_level(e: mvc_event):
	get_tree().change_scene_to_file("res://view/level/level_select.tscn")
	
func _goto_level(e: mvc_event):
	var level: int = e.data.level
	var current_map: mvc_proxy = app().get_proxy("current_map")
	if current_map.data().is_empty():
		return
	
	# 获取目标地图配置
	var level_proxy: mvc_level = app().get_proxy(current_map.data())
	if level_proxy == null:
		return
	
	# 合法性检查
	var level_grid = level_proxy.get_level(level)
	if level_grid == null:
		return
	#level_proxy.debug_print_level_data(level)
	
	# 设置当前关卡号
	var current_level: mvc_proxy = Game.app.get_proxy("current_level")
	current_level.set_data(level)
	
	# 保留原始地图
	var source_grid: level_grid2d = app().get_proxy("source_map").data()
	source_grid.copy_from(level_grid)
	
	# 加载并显示关卡
	get_tree().change_scene_to_file("res://view/room/room.tscn")
	await get_tree().tree_changed
	
	# 初始化移动步数
	var move_count: mvc_proxy = Game.app.get_proxy("move_count")
	move_count.set_data(0)
	
	# 初始化地板、墙壁、目标点、箱子、玩家
	var room_grid: level_grid2d = app().get_proxy("room_map").data()
	var box_grid: level_grid2d = app().get_proxy("box_map").data()
	var goal_list: mvc_proxy = app().get_proxy("goal_list")
	
	room_grid.clear()
	room_grid.resize(level_grid.size())
	
	box_grid.clear()
	box_grid.resize(level_grid.size())
	
	goal_list.data().clear()
	
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
					goal_list.data().append(cell)
				level_const.Tile.PLAYER:
					room_grid.set_tile(cell, level_const.Tile.FLOOR)
					var view = preload("res://view/player/player.tscn").instantiate()
					var player: mvc_player = app().get_proxy("player")
					player.set_data(view)
					player.set_position(cell)
					view.position = Vector3(cell.x * 2 + 1, 0, cell.y * 2 + 1)
				level_const.Tile.BOX:
					room_grid.set_tile(cell, level_const.Tile.FLOOR)
					var view = preload("res://view/room/box.tscn").instantiate()
					box_grid.set_tile(cell, view)
					view.position = Vector3(cell.x * 2, 0, cell.y * 2)
	
