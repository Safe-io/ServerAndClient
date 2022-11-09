extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"

var my_data = {
		
}


var AlliesManager

var myID

var playerPosition 
var player_node
var Player


func _ready():
	
	Player = $Player
	AlliesManager = $AlliesManager
	
	$UpdateTimer.connect("timeout", self, "update_allies_data")

	var err = ws.connect_to_url(URL)
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	if err != OK:
		print("Connection Refused")
		set_process(false)
		
	player_node = get_tree().root.get_child(0).get_child(0)
	
func _closed(_was_clean = false):
	print("Connection Closed")

func _connected():
	print("Conectou ao Servidor")
	
func _on_data():
	#AO RECEBER OU ENVIAR PACOTES, UTILIZE O FORMATO "STRING"
	var payload =  JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8())
	if payload.result == null:
		return
		
	if payload.result.has("assignid"):
		myID = payload.result["assignid"]
		#my_data["id"] = myID
		print("My ID was assigned: " + str(myID))
		send_player_position()
		$UpdateTimer.start()
	else:

		for id in payload.result.keys():
			if(id == str(myID)):
				continue
			#Percorre todos os outros Allies
			if (AlliesManager.ally_exists(id) == false):
				AlliesManager.create_ally(id)
			

			if (payload.result[id].has_all(["x","y"])):
				update_allies_position(id, payload)
				
			if (payload.result[id].has("r")):
				var CurrentAllyRotation = payload.result[id]['r']
				AlliesManager.update_ally_rotation(id, CurrentAllyRotation)
			
			
func _process(delta):
	ws.poll()

func update_allies_data():
	#send_player_position()
	send_player_rotation()

func send_player_position():
	my_data["x"] = Player.position.x
	my_data["y"] = Player.position.y
	ws.get_peer(1).put_packet(JSON.print(my_data).to_utf8())

func send_player_rotation():
	var my_rotation_data : Dictionary 
	
	my_rotation_data = {"r": int(Player.rotation_degrees) } 
	ws.get_peer(1).put_packet(JSON.print(my_rotation_data).to_utf8())
	
func update_allies_position(id, payload):
	var CurrentAllyX = payload.result[id]['x']
	var CurrentAllyY = payload.result[id]['y']
	var CurrentAllyPosition = Vector2(CurrentAllyX, CurrentAllyY)
	AlliesManager.update_ally_position(id, CurrentAllyPosition)
	
func update_allies_rotation(id, payload):
	pass
