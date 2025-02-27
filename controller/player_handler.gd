extends MVCHandler

# override
func _on_enter(a: MVCApp):
	a.add_callable("goto_level", _on_goto_level)
	a.add_callable("exit_level", _on_exit_level)
	a.add_callable("on_player_process", _on_player_process)
	
# override
func _on_exit(a: MVCApp):
	a.remove_callable("goto_level", _on_goto_level)
	a.remove_callable("exit_level", _on_exit_level)
	a.remove_callable("on_player_process", _on_player_process)
	
func _on_goto_level(e: MVCEvent):
	Game.add_process("on_player_process")
	
func _on_exit_level(e: MVCEvent):
	Game.remove_process("on_player_process")
	
func _on_player_process(e: MVCEvent):
	var player: MVCPlayer = get_proxy("player")
	if player.data() == null:
		return
	
	var view: Node3D = player.data()
	var cell = Vector2(view.position.x / 2.0, view.position.z / 2.0)
	player.set_position(cell)
	
