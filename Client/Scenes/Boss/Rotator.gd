extends Node2D

var rotate_speed: float
var fire_rate : float 
var bullet_speed  :float 
var bullet_rotation_degrees_per_frame: float

onready var BossCannon = $BossCannon

func _ready():
	BossCannon.set_fire_rate(fire_rate)

func _physics_process(delta):
	rotate(deg2rad(1.5))

func set_variables(_fire_rate, _bullet_speed, _bullet_rotation_degrees_per_frame):
	BossCannon.fire_rate = _fire_rate
	BossCannon.bullet_speed = _bullet_speed
	BossCannon.bullet_rotation_degrees_per_frame = _bullet_rotation_degrees_per_frame
	
	
func smoothly_rotate_to_target(agent, target, delta):
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))
