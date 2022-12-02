extends Cannon

var MainNode
var Player
var PlayerParent
var MagicShotSound

func _ready():
	Player = get_parent()
	PlayerParent = Player.get_parent()
	pool_parent = PlayerParent
	bullet_scene = load("res://Scenes/Bullet/PeashooterBullet.tscn")
	
	initialize_pool_size()
	insntantiate_bullet_pool()
	
