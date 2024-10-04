extends CharacterBody3D

@onready var _animation_player = $Knight/AnimationPlayer
@onready var _skin = $Knight

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _speed_scale: float = 1.0
var _move_direction: Vector2
const _speed: float = 300

func _ready() -> void:
	position = Vector3(position.x, 2*3, 1)
	
func _physics_process(delta: float) -> void:
	# 按键输入
	_move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = Vector3(_move_direction.x, 0, _move_direction.y) * _speed * delta * _speed_scale
	
	if Input.is_action_just_pressed("run"):
		_animation_player.speed_scale = 2
		_speed_scale = 2
	elif Input.is_action_just_released("run"):
		_animation_player.speed_scale = 1
		_speed_scale = 1
	
	# 计算重力影响
	#if not is_on_floor():
	#	velocity.y -= _gravity * delta * 52
	
	# 播放动画
	if _move_direction.is_zero_approx():
		if _animation_player.current_animation != "Idle":
			_animation_player.play("Idle")
	else:
		if _animation_player.current_animation != "Walking_A":
			_animation_player.play("Walking_A")
	
	# 动画旋转
	if abs(velocity.x) + abs(velocity.z) > 0.1:
		var characterDir = Vector2(velocity.z, velocity.x)
		var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, characterDir.angle(), 0))
		_skin.quaternion = _skin.quaternion.slerp(target_quaternion, delta * 10)
	
	# 物理移动
	move_and_slide()
	
func is_pushing_box(box: Node3D) -> bool:
	# 角色没在移动
	if _move_direction.is_zero_approx():
		return false
	# 距离超过一格
	var my_cell = get_cell()
	var box_cell = box.get_cell()
	var vector = (my_cell - box_cell).abs()
	if vector.x + vector.y >= 2:
		return false
	# 没有面向箱子
	if not is_face_to(box):
		return false
	return true
	
func is_face_to(node: Node3D) -> bool:
	return get_cell() + _move_direction == node.get_cell()
	
func get_cell() -> Vector2:
	return Vector2(int(position.x / 2.0), int(position.z / 2.0))
	
func push_box(box: Node3D):
	Game.app.notify("pushbox", {
		"player": self,
		"box": box,
		"dir": _move_direction,
	})
	
func play_animation(name: String):
	_animation_player.play(name)
	
func on_pause():
	set_physics_process(false)
	play_animation("Idle")
	
func on_resume():
	set_physics_process(true)
	_animation_player.speed_scale = 1
	_speed_scale = 1
	
