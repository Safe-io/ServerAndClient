extends Bullet
var sprite
var default_scale
var Player
var Boss
var PlayerParent

func _ready():
	PlayerParent = get_parent()
	Player = PlayerParent.get_child(0)
	Boss = get_tree().root.get_child(0).get_node("Boss")
	movement_speed = 1000
	max_range     = 3000
	sprite = $Sprite
	default_scale = sprite.scale * 2
	
func _physics_process(_delta: float)-> void:
	sprite.scale = sprite.scale * 0.985
	if movement_direction:
		move_bullet(_delta)
		increase_travelled_distance()
		if travelled_distance >= max_range:
			turn_bullet_off()

func turn_bullet_on():
	damage = 1000/(Player.global_position.distance_to(Boss.global_position))
	sprite.scale = default_scale
	travelled_distance = 0
	if self.is_visible() == false:
		self.set_visible(true)
		self.set_physics_process(true)
