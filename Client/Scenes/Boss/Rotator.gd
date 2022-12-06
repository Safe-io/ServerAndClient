extends Node2D

var rotate_speed: float

func smoothly_rotate_to_target(agent, target, delta):
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))

