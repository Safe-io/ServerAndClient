extends Node2D

class_name Cannon

var bullet_scene
var current_bullet
var angle = 15
var pool_parent
var fire_rate: float = 15.0
var pool_size

var bullets_pool := []
var index := 0

var time_between_each_bullet: float = 1.0 / fire_rate
var delta_sum : float = 0

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(pool_parent.rotation)
	cap_bullet_count_on_shooting()
	increase_delta_sum(delta)

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

func initialize_pool_size():
	pool_size = fire_rate * 2.5

func insntantiate_bullet_pool():
	for i in pool_size:
		instantiate_bullet()

func instantiate_bullet():
	current_bullet = bullet_scene.instance()
	bullets_pool.append(current_bullet)
	get_parent().call_deferred("add_child", current_bullet)
	current_bullet.turn_bullet_off()

func cap_bullet_count_on_shooting():
	if delta_sum > time_between_each_bullet:
		delta_sum = time_between_each_bullet

func increase_delta_sum(delta):
	delta_sum += delta

