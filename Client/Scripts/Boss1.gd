extends Node2D


var rotate_speed = 30
var shoote_time_wait_time = 0.2
var spawn_point_count = 6
var bullet_speed = 500


var rotater 

var bullet_scene = preload("res://Scenes/Boss1Bullet.tscn")

func _ready():
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
	
func _on_ShootTimer_timeout() -> void:
	for s in $Rotater.get_children():
		var bullet = bullet_scene.instance()
		bullet.speed = bullet_speed
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
	


func _on_Area2D_area_entered(area):
	pass


func _on_ReverseRotation_timeout():
	rotate_speed = rotate_speed * -1
