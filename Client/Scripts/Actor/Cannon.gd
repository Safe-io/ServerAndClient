extends Node2D

class_name Cannon

var is_shooting: bool 

var bullet_scene
var current_bullet
var angle = 0
var pool_parent
var cannon_parent
var fire_rate: float
var pool_size
var bullet_movement_speed

var bullets_pool := []
var index := 0

var time_between_each_bullet
var delta_sum : float = 0

func _physics_process(delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(cannon_parent.rotation)
	cap_bullet_count_on_shooting()
	increase_delta_sum(delta)
	if is_shooting:
		if(delta_sum > time_between_each_bullet):
			var remainder = fmod(delta_sum, time_between_each_bullet)

			var bullets_to_spawn = round((delta_sum - remainder) / time_between_each_bullet)
			delta_sum = remainder

			for i in bullets_to_spawn:
				var current_bullet = bullets_pool[index]
				current_bullet.turn_bullet_on()
				index = wrapi(index + 1, 0, pool_size)
				current_bullet.is_player_bullet = true
				current_bullet.global_position = global_position
				current_bullet.set_direction(direction.rotated(rand_range((-angle/2)* 0.0174533, (angle/2)*0.0174533)))
				#MagicShotSound.play()


func initialize_bullet_scene(scene):
	bullet_scene = scene
func initialize_pool_parent(parent):
	pool_parent = parent

func initialize_cannon_parent(parent):
	cannon_parent = parent
	
func initialize_pool_size(size):
	pool_size = size

func insntantiate_bullet_pool():
	for i in pool_size:
		instantiate_bullet()

func instantiate_bullet():
	current_bullet = bullet_scene.instance()
	bullets_pool.append(current_bullet)
	pool_parent.call_deferred("add_child", current_bullet)
	current_bullet.turn_bullet_off()

func cap_bullet_count_on_shooting():
	if delta_sum > time_between_each_bullet:
		delta_sum = time_between_each_bullet

func increase_delta_sum(delta):
	delta_sum += delta
	
func set_bullet_movement_speed(movement_speed: float):
	bullet_movement_speed = movement_speed

func set_fire_rate(_fire_rate: float):
	fire_rate = _fire_rate
	time_between_each_bullet = 1.0 / fire_rate


