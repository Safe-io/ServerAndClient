extends Node

var allies : Dictionary = {}
var ally_scene = preload("res://Scenes/Ally.tscn")

func create_ally(id: int):
	var ally_instance = ally_scene.instance() 
	get_tree().root.get_child(0).add_child(ally_instance)
	allies[id] = ally_instance

func ally_exists(id: int):
	return allies.has(id)

func update_ally_position(id: int, position: Vector2):
	allies[id].position = position
	
