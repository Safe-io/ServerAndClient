extends Node

var allies : Dictionary = {}
var player_scene = preload("res://Scenes/Player/Player.tscn")
var ally_scene = preload("res://Scenes/Player/Ally.tscn")

const CLIENT_DISCONNECTED = 404

var last_pos : Dictionary = {}

func create_player(player_id: String):
	last_pos[player_id] = {"x" : 0, "y" : 0}
	var player_instance = player_scene.instance() 
	player_instance.get_child(0).id = player_id 
	get_tree().root.get_child(0).add_child(player_instance)
	allies[player_id] = player_instance.get_node("Player")
	
func create_ally(id: String):
	last_pos[id] = {"x" : 0, "y" : 0}
	var ally_instance = ally_scene.instance() 
	ally_instance.get_child(0).id = id
	get_tree().root.get_child(0).add_child(ally_instance)
	allies[id] = ally_instance.get_node("Ally")

func remove_ally(id: String):
	allies[id].get_parent().queue_free()
	allies.erase(id)


func ally_exists(id: String) -> bool:
	return allies.has(id)

func update_ally_position(id: String, ally_position: Vector2):
	allies[id].position = ally_position
	
func update_ally_direction(id: String, ally_direction: Vector2):
	allies[id].movement_direction = ally_direction

func update_ally_rotation(id: String, rotation: float):
	allies[id].rotation_degrees = rotation
	
func update_ally_is_shooting(id: String, is_shooting: bool):
	allies[id].is_shooting = is_shooting

func update_allies_status(payload: Dictionary, client_id: String):
	for id in payload.keys():

		if(id == client_id):
			continue
		
		if (ally_exists(id) == false):
			create_ally(id)

		var ally_data = payload[id]
		
		if (ally_data.has("err")):
			if(ally_data['err'] == CLIENT_DISCONNECTED):
				remove_ally(id)
				return
				
		if (ally_data.has_all(["posx","posy"])):
			if (last_pos[id]['x'] != ally_data['posx']) or (last_pos[id]['y'] != ally_data['posy']):
				last_pos[id]["x"] = ally_data['posx']
				last_pos[id]["y"] = ally_data['posy']
				update_ally_position(id, Vector2(ally_data['posx'], ally_data['posy']))

		if (ally_data.has_all(["dirx","diry"])):
			update_ally_direction(id, Vector2(ally_data['dirx'], ally_data['diry']))
			
		if (ally_data.has("r")):
			update_ally_rotation(id, ally_data['r'])
		
		if (ally_data.has("s")):
			update_ally_is_shooting(id, ally_data['s'])
