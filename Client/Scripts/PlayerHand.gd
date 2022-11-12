extends Sprite


var bullet_types: Dictionary = {
	'peashooter' : {
		'damage'    : 10,
		'fire_rate' : 1000,
		'speed'     : 20,
		'range'     : 200,
		'angle'     : 1
	},
	'spreadshot':{
		'damage'    : 30,
		'fire_rate' : 80,
		'speed'     : 20,
		'range'     : 50,
		'angle'     : 7
	}
}

var MainNode
var Player

var bullet_type    = 'peashooter'  
var bullet_aspects = bullet_types[bullet_type]
var bullet_scene  := load("res://Scenes/"+bullet_type +"Bullet.tscn")

var fire_rate = bullet_aspects['fire_rate']
var pool_size = fire_rate * 1.5

var _bullet_pool := []
var _index := 0

func _ready():
	MainNode = get_tree().root.get_child(0)
	Player = get_tree().root.get_child(0).get_child(0)
	for i in pool_size:
		var current_bullet = bullet_scene.instance()
		_bullet_pool.append(current_bullet)
	
func _process(delta: float) -> void:
	rotate(PI/2)
	var direction = Vector2.RIGHT.rotated(Player.rotation)
	
	if Input.is_action_pressed("shoot_1"):
		var bullets_to_spawn := round(fire_rate * delta)
		for i in bullets_to_spawn:
			var current_bullet = _bullet_pool[_index]
			_index = wrapi(_index + 1, 0, pool_size)
			MainNode.add_child(current_bullet)
			current_bullet.global_position = global_position
			current_bullet.set_direction(direction.rotated(rand_range(-PI/4, PI/4)))


