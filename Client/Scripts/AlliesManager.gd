extends Node

var allies : Dictionary = {}
var ally_scene = preload("res://Scenes/Ally.tscn")

func create_ally(id: String):
	var ally_instance = ally_scene.instance() 
	get_tree().root.get_child(0).add_child(ally_instance)
	allies[id] = ally_instance

func ally_exists(id: String) -> bool:
	return allies.has(id)

func update_ally_position(id: String, position: Vector2):
	allies[id].position = position
	
func update_ally_rotation(id: String, rotation: float):
	allies[id].rotation_degrees = rotation
	
func update_ally_is_shooting(id: String, is_shooting: bool):
	allies[id].is_shooting = is_shooting

func update_allies_status(payload: JSONParseResult, client_id: String):
	# Agora está funfando. Ass: BRDMM
	for id in payload.result.keys():
		if(id == str(client_id)):
			continue
		
		if (ally_exists(id) == false):	
			create_ally(id)
		
		if (payload.result[id].has_all(["x","y"])):
			update_ally_position(id, Vector2(payload.result[id]['x'], payload.result[id]['y']))
			
		if (payload.result[id].has("r")):
			update_ally_rotation(id, payload.result[id]['r'])
		
		if (payload.result[id].has("s")):
			update_ally_is_shooting(id, payload.result[id]['s'])
