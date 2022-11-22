extends Node2D

var HitSound
onready var MainNode = get_tree().root.get_child(0)

var rotate_speed : int = 30
var shoote_time_wait_time : float = 0.2
var spawn_point_count : int = 6
var bullet_speed : int = 500

var max_health: float = 2000
var health_points : float = 2000.0

var rotater 
onready var hp_bar = $HPBar
var bullet_scene = preload("res://Scenes/Boss1Bullet.tscn")

func _ready():
	HitSound = $HitSound
	rotater = $Rotater
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(110, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		$Rotater.add_child(spawn_point)
	
	$ShootTimer.wait_time = shoote_time_wait_time
	$ShootTimer.start()
		
func _physics_process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	$Rotater.rotation_degrees = fmod(new_rotation, 360)
	$Label.text = String (health_points)


	
func _on_ShootTimer_timeout() -> void:
	for s in $Rotater.get_children():
		var bullet = bullet_scene.instance()
		bullet.speed = bullet_speed
		get_tree().root.add_child(bullet)
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
