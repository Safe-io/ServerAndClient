extends Sprite


var bullet_types: Dictionary = {
	'peashooter' : {
		'damage'    : 1,
		'fire_rate' : 5,
		'speed'     : 20,
		'range'     : 200,
		'angle'     : 20
	},
	'spreadshot':{
		'damage'    : 30,
		'fire_rate' : 80,
		'speed'     : 20,
		'range'     : 50,
		'angle'     : 1
	}
}

var MainNode
var Player

var bullet_type    = 'peashooter'  
var bullet_aspects = bullet_types[bullet_type]
var bullet_scene  := load("res://Scenes/"+bullet_type +"Bullet.tscn")

var fire_rate: float = bullet_aspects['fire_rate']
var pool_size = fire_rate * 1.5
var angle     = bullet_aspects['angle'] 

var _bullet_pool := []
var _index := 0

var time_between_each_bullet: float = 1.0 / fire_rate
var delta_sum = 0

func _ready():

	MainNode = get_tree().root.get_child(0)
	Player = get_parent()
	for i in pool_size:
		var current_bullet = bullet_scene.instance()
		_bullet_pool.append(current_bullet)
	
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(Player.rotation)
	if delta_sum > time_between_each_bullet:
		delta_sum = time_between_each_bullet
	delta_sum += delta
	if Input.is_action_pressed("shoot_1"):
	
		if(delta_sum > time_between_each_bullet):
			var remainder = fmod(delta_sum, time_between_each_bullet)

			var bullets_to_spawn = round((delta_sum - remainder) / time_between_each_bullet)
			delta_sum = remainder
			
			for i in bullets_to_spawn:
				var current_bullet = _bullet_pool[_index]
				_index = wrapi(_index + 1, 0, pool_size)
				MainNode.add_child(current_bullet)
				current_bullet.global_position = global_position
				current_bullet.set_direction(direction.rotated(rand_range((-angle/2)* 0.0174533, (angle/2)*0.0174533)))
