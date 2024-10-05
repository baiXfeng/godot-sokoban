extends mvc_handler

# override
func _on_enter(a: mvc_app):
	a.add_callable("record_step", _record_step)
	a.add_callable("back_step", _back_step)
	
# override
func _on_exit(a: mvc_app):
	a.remove_callable("record_step", _record_step)
	a.remove_callable("back_step", _back_step)
	
func _record_step(e: mvc_event):
	# 记录步骤
	var from: Vector2 = e.data.from
	var to: Vector2 = e.data.to
	var record: back_step = back_step.new()
	record.from_cell = from
	record.to_cell = to
	
	# 加入列表
	var list: mvc_proxy = app().get_proxy("step_record")
	list.data().append(record)
	
func _back_step(e: mvc_event):
	# 如果没有记录, 直接返回
	var list: mvc_proxy = app().get_proxy("step_record")
	if list.data().is_empty():
		return
	
	# 回退一步
	var step: back_step = list.data().back()
	var player: Node3D = app().get_proxy("player").data()
	var box_grid: level_grid2d = app().get_proxy("box_map").data()
	var box: Node3D = box_grid.get_tile(step.to_cell)
	
	# 移动中直接返回
	if not box or box.moving():
		return
	
	# 移除记录
	list.data().pop_back()
	
	# 更新移动步数
	var move_count: mvc_proxy = app().get_proxy("move_count")
	move_count.set_data( move_count.data() + 1 )
	
	# 更新箱子位置
	box_grid.set_tile(step.to_cell, null)
	box_grid.set_tile(step.from_cell, box)
	
	# 角色硬直, 箱子回退
	var dir: Vector2 = step.to_cell.direction_to(step.from_cell)
	player.on_pause()
	await box.move_direction(dir).on_move_finished
	player.on_resume()
	
