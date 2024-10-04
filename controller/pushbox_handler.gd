extends mvc_handler

# override
func _on_enter(a: mvc_app):
	a.add_callable("pushbox", _pushbox)
	
# override
func _on_exit(a: mvc_app):
	a.remove_callable("pushbox", _pushbox)
	
func _pushbox(e: mvc_event):
	var player: Node3D = e.data.player
	var box: Node3D = e.data.box
	var dir: Vector2 = e.data.dir
	
	# 箱子在移动中, 直接返回
	if box.moving():
		return
	
	# 判断箱子前方是否有障碍
	var box_grid: level_grid2d = app().get_proxy("box_map").data()
	var curr_cell: Vector2 = box.get_cell()
	var next_cell: Vector2 = curr_cell + dir
	
	# 前方有箱子, 直接返回
	assert(box_grid.get_tile(curr_cell) == box, "箱子地图数据错误!")
	if box_grid.has_tile(next_cell):
		return
	
	# 前方有墙壁
	var room_grid: level_grid2d = app().get_proxy("room_map").data()
	if room_grid.has_tile(next_cell) and room_grid.get_tile(next_cell) == level_const.Tile.WALL:
		return
	
	# 更新箱子位置
	box_grid.set_tile(curr_cell, null)
	box_grid.set_tile(next_cell, box)
	
	# 更新移动步数
	var move_count: mvc_proxy = Game.app.get_proxy("move_count")
	move_count.set_data( move_count.data() + 1 )
	
	# 角色硬直
	player.on_pause()
	await box.move_direction(dir).on_move_finished
	player.on_resume()
	
	# 判断胜利
	var goal_list: Array = app().get_proxy("goal_list").data()
	for cell in goal_list:
		if not box_grid.has_tile(cell):
			return
	
	# 获得胜利
	printt("胜利")
	
