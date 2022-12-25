extends Bullet
var sprite
var default_scale
var Player
var Boss
var PlayerParent
var distance

var near_range = 350
var far_range = 1450

var normalized_distance
var min_damage = 2
var max_damage = 10


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
	distance = (Player.global_position.distance_to(Boss.global_position))
	normalized_distance = (distance - near_range) / (far_range - near_range)

	damage = (normalized_distance * min_damage + (1 - normalized_distance)* max_damage)
	damage = clamp(damage, min_damage, max_damage)
	print (damage,"  ", normalized_distance)
	sprite.scale = default_scale
	travelled_distance = 0
	if self.is_visible() == false:
		self.set_visible(true)
		self.set_physics_process(true)
