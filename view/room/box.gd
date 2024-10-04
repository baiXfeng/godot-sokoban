extends Node3D

var _moving: bool
var _player: Node3D
var _push_tick: float

signal on_move_finished(sender)

func move_direction(dir: Vector2):
	_move_direction(dir)
	return self
	
func moving() -> bool:
	return _moving
	
func get_cell() -> Vector2:
	return Vector2(position.x / 2.0, position.z / 2.0)
	
func _move_direction(dir: Vector2):
	# 移动动画
	if _moving:
		return
	_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(dir.x * 2, 0, dir.y * 2), 0.4)
	tween.play()
	await tween.finished
	_moving = false
	on_move_finished.emit(self)
	
func _on_player_entered(body: Node3D) -> void:
	_player = body
	
func _on_player_exited(body: Node3D) -> void:
	_player = null
	
func _physics_process(delta: float) -> void:
	if _player == null:
		return
	if _player.is_pushing_box(self):
		_push_tick += delta
		if _push_tick >= 0.15:
			_player.push_box(self)
			_player = null
	else:
		_push_tick = 0.0
	
