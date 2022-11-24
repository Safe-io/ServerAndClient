extends Sprite

var bullet_types: Dictionary = {
	'Peashooter' : {
		'damage'    : 4000,
		'fire_rate' : 10,
		'speed'     : 2000,
		'range'     : 2000,
		'angle'     : 15,
		'penetration': 0
	},
	'spreadshot':{
		'damage'    : 30,
		'fire_rate' : 80,
		'speed'     : 20,
		'range'     : 50,
		'angle'     : 1,
		'penetration': 0
	}
}

var MainNode
var Player
var PlayerParent
var MagicShotSound

var bullet_type    = 'Peashooter'  
var bullet_aspects = bullet_types[bullet_type]
var bullet_scene  := load("res://Scenes/Bullet/"+bullet_type +"Bullet.tscn")

var fire_rate: float = bullet_aspects['fire_rate']
var pool_size = fire_rate * 2 + 20
var angle     = bullet_aspects['angle'] 


var _ready_bullets_pool := []

var _index := 0

var time_between_each_bullet: float = 1.0 / fire_rate
var delta_sum : float = 0

func _ready():
	
	MainNode = get_tree().root.get_child(0)
	Player = get_parent()
	PlayerParent = Player.get_parent()
	MagicShotSound = Player.get_node("MagicShotSound")
	
	for i in pool_size:
		instantiate_bullet()
	
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(Player.rotation)
	cap_bullet_count_on_shooting()
	increase_delta_sum(delta)
	if Player.is_shooting:
	
		if(delta_sum > time_between_each_bullet):
			var remainder = fmod(delta_sum, time_between_each_bullet)

			var bullets_to_spawn = round((delta_sum - remainder) / time_between_each_bullet)
			delta_sum = remainder
			
			
			for i in bullets_to_spawn:

				var current_bullet = _ready_bullets_pool[_index]
				turn_bullet_on(current_bullet)
				_index = wrapi(_index + 1, 0, pool_size)
				if Player.is_player:
					current_bullet.is_player_bullet = true
				current_bullet.global_position = global_position
				current_bullet.set_direction(direction.rotated(rand_range((-angle/2)* 0.0174533, (angle/2)*0.0174533)))
				MagicShotSound.play()
			
func instantiate_bullet():

	var current_bullet = bullet_scene.instance()
	current_bullet.max_range = bullet_aspects['range']
	current_bullet.speed = bullet_aspects['speed']
	_ready_bullets_pool.append(current_bullet)
	PlayerParent.call_deferred("add_child", current_bullet)
	turn_bullet_off(current_bullet)

func turn_bullet_off(bullet):
	if bullet.is_visible():
		bullet.hide()
		bullet.set_physics_process(false)

func turn_bullet_on(bullet):
	if bullet.is_visible() == false:
		bullet.set_visible(true)
		bullet.set_physics_process(true)
		
func cap_bullet_count_on_shooting():
	if delta_sum > time_between_each_bullet:
		delta_sum = time_between_each_bullet

func increase_delta_sum(delta):
	delta_sum += delta
	
