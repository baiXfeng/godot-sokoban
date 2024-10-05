extends Node

var app: mvc_app = mvc_app.new()

signal on_level_load_completed

# =============================================================================
# public
func add_process(event_name: String):
	_process_map[event_name] = true
	
func remove_process(event_name: String) -> bool:
	return _process_map.erase(event_name)
	
func get_level_proxy_keys() -> Array[String]:
	var result: Array[String]
	for file in _get_level_filenames() as Array[String]:
		result.append("level:%s" % file)
	return result
	
func is_level_loaded() -> bool:
	return _level_loaded
	
# =============================================================================
# private
var _process_map: Dictionary
var _level_loaded: bool
	
func _ready() -> void:
	_register_app()
	app.notify("load_game")	# 读取存档
	
func _physics_process(delta: float) -> void:
	for event in _process_map.keys():
		app.notify(event, {
			"delta": delta,
		})
	
func _register_app():
	# proxy
	app.add_proxy("source_map", mvc_proxy.new(level_grid2d.new()))
	app.add_proxy("room_map", mvc_proxy.new(level_grid2d.new()))	# 墙壁、地板、目标点
	app.add_proxy("box_map", mvc_proxy.new(level_grid2d.new()))		# 箱子
	app.add_proxy("goal_list", mvc_proxy.new([]))	# 目标点列表
	app.add_proxy("player", mvc_player.new())	# 玩家
	app.add_proxy("move_count", mvc_proxy.new(0))	# 移动步数
	app.add_proxy("current_map", mvc_proxy.new(""))	# 当前地图集
	app.add_proxy("current_level", mvc_proxy.new(0))	# 当前关
	app.add_proxy("step_record", mvc_proxy.new([]))
	app.add_proxy("game_data", game_data.new())	# 游戏数据
	
	# controller
	app.add_handler("level_handler", load("res://controller/level_handler.gd").new(self))
	app.add_handler("pushbox_handler", load("res://controller/pushbox_handler.gd").new(self))
	app.add_handler("back_handler", load("res://controller/back_handler.gd").new(self))
	app.add_handler("player_handler", load("res://controller/player_handler.gd").new(self))
	
	# command
	app.add_command("load_game", load("res://command/load_game.gd"))
	app.add_command("save_game", load("res://command/save_game.gd"))
	
	# 延时加载关卡配置
	await get_tree().process_frame
	for file in _get_level_filenames() as Array[String]:
		app.add_proxy("level:%s" % file, mvc_level.new("res://assets/levels/%s" % file))
	on_level_load_completed.emit()
	_level_loaded = true
	
func _unregister_app():
	# proxy
	app.remove_proxy("source_map")
	app.remove_proxy("room_map")
	app.remove_proxy("box_map")
	app.remove_proxy("goal_list")
	app.remove_proxy("player")
	app.remove_proxy("move_count")
	app.remove_proxy("current_map")
	app.remove_proxy("current_level")
	app.remove_proxy("step_record")
	app.remove_proxy("game_data")
	
	# 移除关卡
	for file in _get_level_filenames() as Array[String]:
		app.remove_proxy("level:%s" % file)
	
	# controller
	app.remove_handler("player_handler")
	app.remove_handler("back_handler")
	app.remove_handler("pushbox_handler")
	app.remove_handler("level_handler")
	
	# command
	app.remove_command("load_game")
	app.remove_command("save_game")
	
func _get_level_filenames() -> Array[String]:
	var dir = DirAccess.open("res://assets/levels")
	var result: Array[String]
	if dir:
		result.append_array(dir.get_files())
	return result
	
