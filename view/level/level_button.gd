@tool
extends Control

@onready var _number = $Label
@onready var _star_container = $HBoxContainer
@onready var _lock = $TextureRect2

@export var number: int:
	set(v):
		number = v
		if _number:
			set_number(number)
	
@export var star: int:
	set(v):
		star = v
		if _star_container:
			set_star(star)
	
@export var lock: bool = true:
	set(v):
		lock = v
		if _lock:
			show_lock(lock)
	
func set_number(v: int):
	_number.text = "%d" % v
	
func set_star(v: int):
	var list = _star_container
	printt("星级:", v)
	match v:
		1:
			for i in 3:
				list.get_child(i).highlight = true if i == 1 else false
		2:
			for i in 3:
				list.get_child(i).highlight = true if i != 1 else false
		3:
			for i in 3:
				list.get_child(i).highlight = true
		_:
			for i in 3:
				list.get_child(i).highlight = false
	
func show_lock(v: bool):
	_lock.visible = v
	_number.visible = not v
	_star_container.visible = not v
	
func _ready() -> void:
	number = number
	star = star
	lock = lock
	
