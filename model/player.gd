extends mvc_proxy
class_name mvc_player

signal on_position_changed(sender, position)

var position: Vector2:
	set(v):
		pass
	get:
		return _private_pos
	
func set_position(v: Vector2):
	_private_pos = v
	on_position_changed.emit(self, _private_pos)
	
var _private_pos: Vector2
