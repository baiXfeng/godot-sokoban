@tool
extends Control

@onready var _star_list = [
	$CenterContainer/ResultBox/NinePatchRect/HBoxContainer/VBoxContainer/LevelStar,
	$CenterContainer/ResultBox/NinePatchRect/HBoxContainer/VBoxContainer2/LevelStar,
	$CenterContainer/ResultBox/NinePatchRect/HBoxContainer/VBoxContainer3/LevelStar,
]

@export var star: int:
	set(v):
		star = v
		if _star_list[0]:
			set_star(star)
	
func set_star(v: int):
	var list = _star_list
	match v:
		1:
			for i in 3:
				list[i].highlight = true if i == 1 else false
		2:
			for i in 3:
				list[i].highlight = true if i != 1 else false
		3:
			for i in 3:
				list[i].highlight = true
		_:
			for i in 3:
				list[i].highlight = false
	
func _ready() -> void:
	star = 3
	
func _on_retry_pressed() -> void:
	Game.app.notify("retry_level")
	
func _on_retry_2_pressed() -> void:
	Game.app.notify("next_level")
	
func _on_close_pressed() -> void:
	Game.app.notify("exit_level")
	
