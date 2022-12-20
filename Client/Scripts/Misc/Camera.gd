extends Camera2D

#Look_at no player e smooth na camera
var rotate_speed = 1.3
var Boss 
var Player

func _ready():
	Boss = get_tree().root.get_child(0).get_node("Boss")
	Player = get_tree().root.get_child(0).get_node("PlayerParent").get_node("Player")
	
func smoothly_rotate_to_target(agent, target, delta):
	var distance_to_target = global_position.distance_to(target.global_position)
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	angle_to_target = angle_to_target + deg2rad(90)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))

func _physics_process(delta):
	global_position = Player.global_position
	smoothly_rotate_to_target(self, Boss,delta)

