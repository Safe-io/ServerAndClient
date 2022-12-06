extends Cannon

var Boss
var Rotator

var bullet_rotation_degrees_per_frame: float

func _ready():

	Boss = get_parent().get_parent()
	Rotator = Boss.get_node("Rotator")
	pool_parent = Boss
	bullet_scene = load("res://Scenes/Bullet/Boss1Bullet.tscn")

	initialize_pool_parent(pool_parent)
	initialize_cannon_parent(Rotator)
	initialize_pool_size(1000)
	insntantiate_bullet_pool()

func _on_StartShooting_timeout():
	is_shooting = true
