extends Control

@onready var _grid_container = $MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/MarginContainer/GridContainer

func _ready() -> void:
	var level: mvc_level = Game.app.get_proxy("level:brithday")
	var button_class = preload("res://view/level/level_button.tscn")
	for i in level.get_level_max():
		var view = button_class.instantiate()
		_grid_container.add_child(view)
		view.number = i + 1
		view.lock = false
	
func _on_close_pressed() -> void:
	pass # Replace with function body.
	
