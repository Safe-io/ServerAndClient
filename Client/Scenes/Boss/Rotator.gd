extends Node2D

var rotate_speed: float
var fire_rate : float = 10
var bullet_speed  :float 
var bullet_rotation_degrees_per_frame: float

onready var BossCannonScene = load("res://Scenes/Boss/BossCannon.tscn")
var BossCannon

func _physics_process(delta):
	rotate(deg2rad(rotate_speed))

func set_variables(_fire_rate, _bullet_speed, _bullet_rotation_degrees_per_frame, rotation_speed):
	rotate_speed = rotation_speed
	BossCannon = BossCannonScene.instance()
	BossCannon.set_fire_rate(_fire_rate)
	BossCannon.bullet_speed = _bullet_speed
	BossCannon.bullet_rotation_degrees_per_frame = _bullet_rotation_degrees_per_frame
	add_child(BossCannon)
	BossCannon.is_shooting = true
	
func smoothly_rotate_to_target(agent, target, delta):
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))
