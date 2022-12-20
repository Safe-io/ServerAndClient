extends Cannon

var MainNode
var Player
var PlayerParent
var MagicShotSound
var Boss



func _ready():
	angle = 25
	Player = get_parent()
	PlayerParent = Player.get_parent()
	Boss = get_tree().root.get_child(0).get_node("Boss")
	pool_parent = PlayerParent
	bullet_scene = load("res://Scenes/Bullet/PeashooterBullet.tscn")
	set_fire_rate(10)
	initialize_pool_parent(PlayerParent)
	initialize_cannon_parent(Player)
	initialize_pool_size(200)
	insntantiate_bullet_pool()
	
func insntantiate_bullet_pool():
	for i in pool_size:
		instantiate_bullet()
		
func instantiate_bullet():
	current_bullet = bullet_scene.instance()
	bullets_pool.append(current_bullet)
	pool_parent.call_deferred("add_child", current_bullet)
	current_bullet.turn_bullet_off()




