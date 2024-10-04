extends CharacterBody3D

@onready var _animation_player = $Knight/AnimationPlayer
@onready var _skin = $Knight

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
const _speed: float = 300
var _speed_scale: float = 1.0

func _ready() -> void:
	position = Vector3(position.x, 2*3, 1)
	
func _physics_process(delta: float) -> void:
	# 按键输入
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = Vector3(direction.x, 0, direction.y) * _speed * delta * _speed_scale
	
	if Input.is_action_just_pressed("run"):
		_animation_player.speed_scale = 2
		_speed_scale = 2
	elif Input.is_action_just_released("run"):
		_animation_player.speed_scale = 1
		_speed_scale = 1
	
	# 计算重力影响
	if not is_on_floor():
		velocity.y -= _gravity * delta * 52
	
	# 播放动画
	if direction.is_zero_approx():
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
	
