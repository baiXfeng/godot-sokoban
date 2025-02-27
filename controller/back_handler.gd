extends MVCHandler

# override
func _on_enter(a: MVCApp):
	a.add_callable("record_step", _record_step)
	a.add_callable("BackStep", _BackStep)
	
# override
func _on_exit(a: MVCApp):
	a.remove_callable("record_step", _record_step)
	a.remove_callable("BackStep", _BackStep)
	
func _record_step(e: MVCEvent):
	# 记录步骤
	var from: Vector2 = e.data.from
	var to: Vector2 = e.data.to
	var record: BackStep = BackStep.new()
	record.from_cell = from
	record.to_cell = to
	
	# 加入列表
	var list: MVCProxy = get_proxy("step_record")
	list.data().append(record)
	
func _BackStep(e: MVCEvent):
	# 如果没有记录, 直接返回
	var list: MVCProxy = get_proxy("step_record")
	if list.data().is_empty():
		return
	
	# 回退一步
	var step: BackStep = list.data().back()
	var player: Node3D = get_proxy("player").data()
	var box_grid: LevelGrid2d = get_proxy("box_map").data()
	var box: Node3D = box_grid.get_tile(step.to_cell)
	
	# 移动中直接返回
	if not box or box.moving():
		return
	
	# 移除记录
	list.data().pop_back()
	
	# 更新移动步数
	var move_count: MVCProxy = get_proxy("move_count")
	move_count.set_data( move_count.data() + 1 )
	
	# 更新箱子位置
	box_grid.set_tile(step.to_cell, null)
	box_grid.set_tile(step.from_cell, box)
	
	# 角色硬直, 箱子回退
	var dir: Vector2 = step.to_cell.direction_to(step.from_cell)
	player.on_pause()
	await box.move_direction(dir).on_move_finished
	player.on_resume()
	
