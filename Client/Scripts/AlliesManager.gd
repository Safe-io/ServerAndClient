extends Node

var allies : Dictionary = {}
var ally_scene = preload("res://Scenes/Player/Player.tscn")
const CLIENT_DISCONNECTED = 404

func create_ally(id: String):
	var ally_instance = ally_scene.instance() 
	ally_instance.get_child(0).id = id
	get_tree().root.get_child(0).add_child(ally_instance)
	allies[id] = ally_instance.get_node("Player")

func remove_ally(id: String):
	allies[id].get_parent().queue_free()
	allies.erase(id)
	print("pao")

func ally_exists(id: String) -> bool:
	return allies.has(id)

func update_ally_position(id: String, position: Vector2):
	allies[id].position = position
	
func update_ally_rotation(id: String, rotation: float):
	allies[id].rotation_degrees = rotation
	
func update_ally_is_shooting(id: String, is_shooting: bool):
	allies[id].is_shooting = is_shooting

func update_allies_status(payload: JSONParseResult, client_id: String):
	for id in payload.result.keys():

		if(id == client_id):
			continue
		
		if (ally_exists(id) == false):
			create_ally(id)

		var ally_data = payload.result[id]
		
		if (ally_data.has("err")):
			if(ally_data['err'] == CLIENT_DISCONNECTED):
				remove_ally(id)
				return
		
		if (ally_data.has_all(["x","y"])):
			update_ally_position(id, Vector2(ally_data['x'], ally_data['y']))
			
		if (ally_data.has("r")):
			update_ally_rotation(id, ally_data['r'])
		
		if (payload.result[id].has("s")):
			update_ally_is_shooting(id, ally_data['s'])
