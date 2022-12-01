extends Node2D

var HitSound
onready var MainNode = get_tree().root.get_child(0)

var rotate_speed : float = 60.0
var shoote_time_wait_time : float = 0.1
var spawn_point_count : int = 6
var bullet_speed : int = 3000
#bullet_speed não altera as formas que são geradas

var max_health: float = 2000
var health_points : float = 2000.0

var Rotator 
onready var hp_bar = $HPBar
var BossCannonScene = preload("res://Scenes/Boss/BossCannon.tscn")
var bullet_scene = preload("res://Scenes/Bullet/Boss1Bullet.tscn")

func _ready():
	HitSound = $HitSound
	Rotator = $Rotator
	
	instantiate_cannons(spawn_point_count)
	
	$ShootTimer.wait_time = shoote_time_wait_time
	$ShootTimer.start()
		
func _physics_process(delta):
	var new_rotation = Rotator.rotation_degrees + rotate_speed * delta
	$Rotator.rotation_degrees = fmod(new_rotation, 360)
	$Label.text = String (health_points)

func _on_ShootTimer_timeout() -> void:
	for s in Rotator.get_children():
		var bullet = bullet_scene.instance()
		bullet.speed = bullet_speed
		MainNode.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
	
func update_boss_health_points(curent_health_points: int):
	health_points = curent_health_points


func _on_Area2D_area_entered(area):
	area.turn_bullet_off(area)
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
		Rotator.add_child(current_boss_cannon)
