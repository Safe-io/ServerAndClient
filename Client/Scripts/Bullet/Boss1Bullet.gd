extends Bullet
var Boss
func _physics_process(delta):
	move_bullet(delta)
	rotate(deg2rad(bullet_rotation_degrees_per_frame))

func _ready():
	Boss = get_parent()
	max_range = INF
	is_player_bullet = false




