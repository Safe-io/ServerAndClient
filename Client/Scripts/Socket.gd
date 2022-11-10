extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"


var AlliesManager

var myID
var Player


func _ready():
	
	Player = $Player
	AlliesManager = $AlliesManager
	
	$UpdateTimer.connect("timeout", self, "send_player_rotation")

	var err = ws.connect_to_url(URL)
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	if err != OK:
		print("Connection Refused")
		set_process(false)
		
	
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
		AlliesManager.update_allies_status(payload, str(myID))
			
			
func _process(delta):
	ws.poll()

func send_player_position():
	var position_data : Dictionary = {'x' : Player.position.x, 'y' : Player.position.y}
	ws.get_peer(1).put_packet(JSON.print(position_data).to_utf8())
	

func send_player_rotation():
	var rotation_data : Dictionary 
	
	rotation_data = {"r": int(Player.rotation_degrees) } 
	ws.get_peer(1).put_packet(JSON.print(rotation_data).to_utf8())
	
