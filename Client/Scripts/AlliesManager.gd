extends Node

var allies : Dictionary = {}
var ally_scene = preload("res://Scenes/Enemy.tscn")
	
func create_ally(id: int):
	var ally_instance = ally_scene.instance() 
	add_child(ally_instance)
	allies[id] = ally_instance

func ally_exists(id: int):
	return allies.has(id)

func update_ally_position(id: int, position: Vector2):
	allies[id].position = position	
