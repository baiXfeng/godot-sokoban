extends Node3D

@onready var _floor_layer = $Floor
@onready var _box_layer = $Box
@onready var _wall_layer = $Wall

@onready var _level = $CanvasLayer/VBoxContainer/level
@onready var _step = $CanvasLayer/VBoxContainer/step
@onready var _time = $CanvasLayer/VBoxContainer/time

var _seconds: float

func _ready() -> void:
	# 监听箱子创建
	var box_grid: level_grid2d = Game.app.get_proxy("box_map").data()
	box_grid.on_set_tile.connect(_on_add_box)
	
	# 监听玩家创建
	var player_proxy: mvc_proxy = Game.app.get_proxy("player")
	player_proxy.on_data_changed.connect(_on_add_player)
	
	# 监听地图初始化
	var room_grid: level_grid2d = Game.app.get_proxy("room_map").data()
	room_grid.on_set_tile.connect(_on_map_set_tile)
	
	# 设置当前关卡号
	var current_level: mvc_proxy = Game.app.get_proxy("current_level")
	_level.text = "当前关卡: %03d" % current_level.data()
	
	# 监听步数变化
	var move_count: mvc_proxy = Game.app.get_proxy("move_count")
	move_count.on_data_changed.connect(_on_move_count_changed)
	
	_floor_layer.clear()
	_box_layer.clear()
	_wall_layer.clear()
	
func _on_add_box(sender: level_grid2d, position: Vector2, box: Node):
	if box == null:
		return
	if box.get_parent() != null:
		return
	_box_layer.add_child(box)
	
func _on_add_player(sender: mvc_proxy, player: Node):
	if player.get_parent() != null:
		return
	add_child(player)
	
func _on_move_count_changed(sender: mvc_proxy, count: int):
	_step.text = "当前步数: %d" % count
	
func _on_map_set_tile(sender: level_grid2d, position: Vector2, tile: int):
	match tile:
		level_const.Tile.FLOOR:
			var tiles = [0, 1, 2]
			_floor_layer.set_cell_item(Vector3(position.x, 0, position.y), tiles.pick_random())
		level_const.Tile.WALL:
			_wall_layer.set_cell_item(Vector3(position.x, 0, position.y), 0)
		level_const.Tile.GOAL:
			_floor_layer.set_cell_item(Vector3(position.x, 0, position.y), 3)
	
func _on_back_pressed() -> void:
	Game.app.notify("exit_level")
	
func _physics_process(delta: float) -> void:
	_seconds += delta
	var ms: float = _seconds - int(_seconds)
	var second: int = int(_seconds) % 60
	var minute: int = int(_seconds) / 60.0
	_time.text = "游戏时间: %02d:%02d:%02d" % [minute, second, ms * 100]
