extends Node2D


var rotate_speed = 100
var shoote_time_wait_time = 0.5
var spawn_point_count = 4
var rotater 

var bullet_scene = preload("res://Scenes/Boss1Bullet.tscn")

func _ready():
	rotater = $Rotater
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(130, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		$Rotater.add_child(spawn_point)
	
	$ShootTimer.wait_time = shoote_time_wait_time
	$ShootTimer.start()
		
func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	$Rotater.rotation_degrees = fmod(new_rotation, 360)
	
func _on_ShootTimer_timeout() -> void:
	for s in $Rotater.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
	


func _on_Area2D_area_entered(area):
	print("ouch")
