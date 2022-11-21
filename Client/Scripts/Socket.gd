extends Node

var ws = WebSocketClient.new()
var URL = "ws://26.17.197.157:3000/"

var AlliesManager

var myID : String
var Player

var frame_data: Dictionary

func _ready():
	
	$Label.set_as_toplevel(true)
	
	AlliesManager = $AlliesManager
	
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
		myID = String(payload.result["assignid"]) 

		print("My ID was assigned: " + myID)
		AlliesManager.create_ally(myID)
		Player = $PlayerParent.get_child(0)
		update_player_position()
	else:
		AlliesManager.update_allies_status(payload, myID)
			
			
func _process(delta):
	ws.poll()
	send_full_data()

	$Label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Label2.text = "Memory Static: " + str(Performance.get_monitor(Performance.MEMORY_STATIC))

func update_player_direction():
	frame_data["dirx"] = Player.direction.x
	frame_data["diry"] = Player.direction.y

func update_player_position():
	frame_data["posx"] = Player.position.x
	frame_data["posy"] = Player.position.y

func update_player_rotation():
	var rotation_data : int = int(Player.rotation_degrees)
	frame_data["r"] = rotation_data

func update_player_is_shooting(is_shooting: bool):
	frame_data["s"] = int(is_shooting) 
	
func send_full_data():
	ws.get_peer(1).put_packet(JSON.print(frame_data).to_utf8())


