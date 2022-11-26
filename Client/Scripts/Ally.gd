extends Node2D
var is_shooting:bool = true
var peashooter_bullet = preload("res://Scenes/PeashooterBullet.tscn")

onready var MainNode = get_tree().root.get_child(0)

func shoot():
	var bullet_instance = peashooter_bullet.instance()
	MainNode.add_child(bullet_instance)
	bullet_instance.global_position = $EndOfHand.global_position
	var bullet_target = $EndOfHand.global_position
	var direction_to_mouse = position.direction_to(bullet_target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	

func _process(delta):
	if(is_shooting):
		shoot()
