extends Bullet

func _process(delta):
	move_bullet(delta)
	rotate(deg2rad(rotation_degrees_per_frame))

func _ready():
	movement_speed = get_parent().bullet_speed

func _on_Area2D_body_entered(body):
	queue_free()
	body.take_damage(1.0)
