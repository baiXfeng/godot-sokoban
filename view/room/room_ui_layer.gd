extends CanvasLayer

@onready var _map1 = $Minimap
@onready var _map2 = $CenterContainer/Control/Minimap

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		if _map1.visible:
			_map1.visible = false
			_map2.visible = true
			_map2.position = _map2.size / 2 * -1
			_map2.pivot_offset = _map2.custom_minimum_size * 0.5
			_map2.scale = Vector2(2, 2)
		elif _map2.visible:
			_map2.visible = false
		else:
			_map1.visible = true
	
