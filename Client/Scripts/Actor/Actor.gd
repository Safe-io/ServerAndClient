extends KinematicBody2D

class_name Actor

var max_health_points : float
var health_points: float = 10.0
var velocity = Vector2()

var AlliesManager
var MainNode


var last_rotation
var last_movement_direction
var movement_direction := Vector2(0,0)
var movement_speed : float

var is_shooting: bool 
var id : String

func initialize_main_node():
	MainNode       = get_tree().root.get_child(0)
func initialize_allies_manager():
	 AlliesManager = MainNode.get_node("AlliesManager")

func take_damage(damage: float):
	if health_points <=0:
		die()
	health_points = health_points - damage
func die():
	pass
