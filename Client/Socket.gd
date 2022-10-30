extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"
var packet = {}
var myID
var conectadoAoServidor = false
var playerPosition 
var player_node






func _ready():
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	var scene = load("res://Player.tscn")
	var instance = scene.instance()
	add_child(instance)
	
	player_node = get_tree().root.get_child(0).get_child(0)
	print(player_node)
	

	
	var err = ws.connect_to_url(URL)
	if err != OK:
		print("Connection Refused")
		set_process(false)
	

		
		
		
func _closed(was_clean = false):
	print("Connection Closed")

func _connected(proto = ""):
	conectadoAoServidor = true
	print("Conectou ao Servidor")
	
	
	
func _on_data():
	packet =  JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8())
	
	if packet.result.has("assignid"):
		myID = packet.result["assignid"]

	
func _process(delta):
	ws.poll()
	
	if(get_child(0) != null):
		playerPosition = (player_node.position)
		pass
	
	player_node.position = playerPosition
	

func send_player_position():
	var payload = JSON.print({"playerposition" : playerPosition,
								"id": myID})
	ws.get_peer(1).put_packet((payload).to_utf8())
	
