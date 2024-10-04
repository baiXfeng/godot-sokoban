extends Node3D

var _moving: bool

func move_direction(dir: Vector2):
	if _moving:
		return
	_moving = true
	
	# 移动动画
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(dir.x * 2, 0, dir.y * 2), 1)
	tween.play()
	await tween.finished
	_moving = false
	
func moving() -> bool:
	return _moving
	
