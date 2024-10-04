extends Control

@onready var _grid_container = $MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var _scroll_container = $MarginContainer/NinePatchRect/MarginContainer/ScrollContainer
@onready var _title = $MarginContainer/NinePatchRect/TextureRect/Label

var button_class = preload("res://view/level/level_button.tscn")

var _list = ["level:akk", "level:brithday", "level:696"]
static var _index = 0

func _ready() -> void:
	Game.app.notify("switch_map", {
		"name": _list[_index],
	})
	_reload_level_list()
	
	await _scroll_container.sort_children
	_scroll_container.scroll_vertical = _scroll_position
	
func _reload_level_list():
	for node in _grid_container.get_children() as Array[Node]:
		node.queue_free()
	var level: mvc_level = Game.app.get_proxy(_list[_index])
	for i in level.get_level_max():
		var view = button_class.instantiate()
		_grid_container.add_child(view)
		view.number = i + 1
		view.lock = false
	_title.text = "关卡选择(%d)" % level.get_level_max()
	
func _on_close_pressed() -> void:
	pass # Replace with function body.
	
func _on_back_map_pressed() -> void:
	_index = _index - 1 if _index - 1 >= 0 else _list.size() - 1
	Game.app.notify("switch_map", {
		"name": _list[_index],
	})
	_reload_level_list()
	printt(_index, _list[_index])
	
func _on_next_map_pressed() -> void:
	_index = _index + 1 if _index + 1 < _list.size() else 0
	Game.app.notify("switch_map", {
		"name": _list[_index],
	})
	_reload_level_list()
	printt(_index, _list[_index])
	
static var _scroll_position: int
	
func _on_tree_exiting() -> void:
	_scroll_position = _scroll_container.scroll_vertical
	
