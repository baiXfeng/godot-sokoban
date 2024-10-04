extends Node

var app: mvc_app = mvc_app.new()

# =============================================================================
# public
func add_process(event_name: String):
	_process_map[event_name] = true
	
func remove_process(event_name: String) -> bool:
	return _process_map.erase(event_name)
	
# =============================================================================
# private
var _process_map: Dictionary
	
func _ready() -> void:
	_register_app()
	
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
	app.add_proxy("current_map", mvc_proxy.new(""))
	app.add_proxy("current_level", mvc_proxy.new(0))
	
	# 加载关卡
	app.add_proxy("level:brithday", mvc_level.new("res://assets/levels/Birthday.txt"))
	app.add_proxy("level:akk", mvc_level.new("res://assets/levels/AKK_Informatika.txt"))
	app.add_proxy("level:696", mvc_level.new("res://assets/levels/696.txt"))
	
	# controller
	app.add_handler("level_handler", load("res://controller/level_handler.gd").new(self))
	app.add_handler("pushbox_handler", load("res://controller/pushbox_handler.gd").new(self))
	
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
	
	# 移除关卡
	app.remove_proxy("level:brithday")
	app.remove_proxy("level:akk")
	app.remove_proxy("level:696")
	
	# controller
	app.remove_handler("pushbox_handler")
	app.remove_handler("level_handler")
	
