extends Control

@onready var _goal_layer = $Node2D/GoalLayer
@onready var _tile_layer = $Node2D/TileLayer
@onready var _player_layer = $Node2D/PlayerLayer
@onready var _map_container = $Node2D
@onready var _mask = $ColorRect

enum Tile {
	WALL = 1,
	GOAL,
	BOX,
	PLAYER,
}

var _last_player_position: Vector2

func _ready() -> void:
	# 监听箱子创建
	var box_grid: level_grid2d = Game.app.get_proxy("box_map").data()
	box_grid.on_set_tile.connect(_on_add_box)
	
	# 监听玩家创建
	var player_proxy: mvc_player = Game.app.get_proxy("player")
	player_proxy.on_position_changed.connect(_on_player_position_chaanged)
	
	# 监听地图初始化
	var room_grid: level_grid2d = Game.app.get_proxy("room_map").data()
	room_grid.on_set_tile.connect(_on_map_set_tile)
	
	await get_tree().create_timer(0.05).timeout
	custom_minimum_size = room_grid.size() * Vector2(32, 32)
	size = custom_minimum_size
	_mask.visible = true
	
	var rect = get_viewport_rect()
	position = Vector2(rect.size.x - size.x - 40, 40)
	
func _on_add_box(sender: level_grid2d, position: Vector2, box: Node):
	if box == null:
		_tile_layer.set_cell(Vector2i(position))
		return
	_tile_layer.set_cell(Vector2i(position), 0, Vector2i(0, 0), Tile.BOX)
	
func _on_player_position_chaanged(sender, position: Vector2):
	if _player_layer.get_cell_alternative_tile(_last_player_position) == Tile.PLAYER:
		_player_layer.set_cell(Vector2i(_last_player_position))
	_player_layer.set_cell(Vector2i(position), 0, Vector2i(0, 0), Tile.PLAYER)
	_last_player_position = position
	
func _on_map_set_tile(sender: level_grid2d, position: Vector2, tile: int):
	match tile:
		level_const.Tile.WALL:
			_tile_layer.set_cell(Vector2i(position), 0, Vector2i(0, 0), Tile.WALL)
		level_const.Tile.GOAL:
			_goal_layer.set_cell(Vector2i(position), 0, Vector2i(0, 0), Tile.GOAL)
	
func copy_from(map):
	map.save_to(self)
	
func save_to(map):
	for cell in _tile_layer.get_used_cells() as Array[Vector2i]:
		map._tile_layer.set_cell(cell, 0, Vector2i(0, 0), _tile_layer.get_cell_alternative_tile(cell))
	for cell in _goal_layer.get_used_cells() as Array[Vector2i]:
		map._goal_layer.set_cell(cell, 0, Vector2i(0, 0), _goal_layer.get_cell_alternative_tile(cell))
	
