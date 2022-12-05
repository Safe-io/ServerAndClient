extends Node2D

var HitSound
onready var MainNode = get_tree().root.get_child(0)
var is_shooting = false

#A bala dará uma volta a cada 6/x segundos
#6/6 = 1 círculo

var rotate_speed : float = 90
var bullet_rotation_degrees_per_frame = 6
var fire_rate = 30

var shoote_time_wait_time : float = 0.1
var cannon_count : int = 3
var bullet_speed : float = 1000
#bullet_speed não altera as formas que são geradas

var max_health: float = 2000
var health_points : float = 2000.0

var Rotator 
var Player
onready var hp_bar = $HPBar
var BossCannonScene = preload("res://Scenes/Boss/BossCannon.tscn")
var bullet_scene = preload("res://Scenes/Bullet/Boss1Bullet.tscn")

func _ready():
	HitSound = $HitSound
	Rotator = $Rotator
	Player = MainNode.get_node("Player")
	instantiate_cannons(cannon_count)

func _physics_process(delta):
	var new_rotation = Rotator.rotation_degrees + rotate_speed * delta
	Rotator.rotation_degrees = fmod(new_rotation, 360)
	
func update_boss_health_points(curent_health_points: int):
	health_points = curent_health_points

func _on_Area2D_area_entered(area):
	area.turn_bullet_off()
	HitSound.play()

	if health_points <=0:
		queue_free()
	if health_points <=1000:
		shoote_time_wait_time = 0.1
		rotate_speed = 40
	if(area.is_player_bullet):
		MainNode.increase_damage_points_dealed_in_the_frame()
	hp_bar.value = (health_points/max_health) * 100

func _on_ReverseRotation_timeout():
	rotate_speed = rotate_speed * -1

func instantiate_cannons(number_of_cannons: int):
	var step = 2 * PI / number_of_cannons
	for index in range(number_of_cannons):
		var current_boss_cannon = BossCannonScene.instance()
		var current_boss_cannon_spawn_position = Vector2(110, 0).rotated(step * index)
		current_boss_cannon.position = current_boss_cannon_spawn_position
		current_boss_cannon.rotation = current_boss_cannon_spawn_position.angle()
		current_boss_cannon.set_bullet_movement_speed(bullet_speed)
		Rotator.add_child(current_boss_cannon)

func smoothly_rotate_to_target(agent, target, delta):
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))


