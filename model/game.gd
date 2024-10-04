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
	app.add_proxy("player", mvc_player.new())	# 玩家
	
	# 加载关卡
	app.add_proxy("level:brithday", mvc_level.new("res://assets/levels/Birthday.txt"))
	
	# controller
	app.add_handler("level_handler", load("res://controller/level_handler.gd").new(self))
	
func _unregister_app():
	# proxy
	app.remove_proxy("room_map")
	app.remove_proxy("box_map")
	app.remove_proxy("player")
	
	# 移除关卡
	app.remove_proxy("level:brithday")
	
	# controller
	app.remove_handler("level_handler")
	
