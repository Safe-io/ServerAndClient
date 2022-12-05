extends Cannon

var Boss
var Rotator

func _ready():

	Boss = get_parent().get_parent()
	Rotator = Boss.get_node("Rotator")
	pool_parent = Boss
	bullet_scene = load("res://Scenes/Bullet/Boss1Bullet.tscn")
	is_shooting = true
	set_fire_rate(Boss.fire_rate)
	initialize_pool_parent(pool_parent)
	initialize_cannon_parent(Rotator)
	initialize_pool_size(1000)
	insntantiate_bullet_pool()
	
