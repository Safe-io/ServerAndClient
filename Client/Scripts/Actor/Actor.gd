extends KinematicBody2D

class_name Actor

var health_points = 10
var velocity = Vector2()

var AlliesManager
var MainNode

func initialize_main_node():
	MainNode       = get_tree().root.get_child(0)
func initialize_allies_manager():
	 AlliesManager = MainNode.get_child(1)
