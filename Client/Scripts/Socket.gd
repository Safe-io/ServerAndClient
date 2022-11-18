extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"


var AlliesManager

var myID : String
var Player

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
	send_player_position()
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
		send_player_position()
	else:
		AlliesManager.update_allies_status(payload, myID)
			
			
func _process(delta):
	ws.poll()
	$Label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Label2.text = "Memory Static: " + str(Performance.get_monitor(Performance.MEMORY_STATIC))

func send_player_position():
	var position_data : Dictionary = {'x' : Player.position.x, 'y' : Player.position.y}
	ws.get_peer(1).put_packet(JSON.print(position_data).to_utf8())

var i = 0
func send_player_rotation():
	i += 1
	print(i)
	var rotation_data : Dictionary = {"r":int(Player.rotation_degrees)} 
	ws.get_peer(1).put_packet(JSON.print(rotation_data).to_utf8())
	
func send_player_is_shooting(is_shooting: bool):
	var is_shooting_data: Dictionary = {'s':int(is_shooting)}
	ws.get_peer(1).put_packet(JSON.print(is_shooting_data).to_utf8())
	

	
	
