extends Bullet
var Boss
func _physics_process(delta):
	move_bullet(delta)
	rotate(deg2rad(Boss.bullet_rotation_degrees_per_frame))

func _ready():
	Boss = get_parent()
	max_range = INF
	movement_speed = get_parent().bullet_speed

func _on_Area2D_body_entered(body):
	queue_free()
	body.take_damage(1.0)
