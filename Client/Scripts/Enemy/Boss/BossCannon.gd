extends Cannon

var Boss
var Rotator

var bullet_rotation_degrees_per_frame: float

func _ready():
	Boss = get_parent().get_parent()
	Rotator = get_parent()
	pool_parent = Rotator.get_parent()
	bullet_scene = load("res://Scenes/Bullet/Boss1Bullet.tscn")

	initialize_pool_parent(pool_parent)
	initialize_cannon_parent(Rotator)
	initialize_pool_size(200)
	instantiate_bullet_pool(fire_rate, bullet_speed, bullet_rotation_degrees_per_frame)

func _on_StartShooting_timeout():
	is_shooting = true


func instantiate_bullet(_fire_rate, _bullet_speed, _bullet_rotation_degrees_per_frame):
	current_bullet = bullet_scene.instance()
	bullets_pool.append(current_bullet)

	current_bullet.movement_speed = _bullet_speed
	current_bullet.bullet_rotation_degrees_per_frame = _bullet_rotation_degrees_per_frame
	pool_parent.call_deferred("add_child", current_bullet)
	current_bullet.turn_bullet_off()
	
func instantiate_bullet_pool(_fire_rate, _bullet_speed, _bullet_rotation_degrees_per_frame):
	for i in pool_size:
		instantiate_bullet(_fire_rate, _bullet_speed, _bullet_rotation_degrees_per_frame)

