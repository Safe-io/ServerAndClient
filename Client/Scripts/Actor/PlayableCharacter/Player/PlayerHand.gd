extends Cannon

var MainNode
var Player
var PlayerParent
var MagicShotSound

func _ready():
	angle = 15
	Player = get_parent()
	PlayerParent = Player.get_parent()
	pool_parent = PlayerParent
	bullet_scene = load("res://Scenes/Bullet/PeashooterBullet.tscn")
	set_fire_rate(10)
	initialize_pool_parent(PlayerParent)
	initialize_cannon_parent(Player)
	initialize_pool_size()
	insntantiate_bullet_pool()
	
