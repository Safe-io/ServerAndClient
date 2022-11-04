extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"

var data = {
		"id" : 0,
		"x"  : 0,
		"y"  : 0
}

var myID
var conectadoAoServidor = false
var playerPosition 
var player_node

var hasCreated = false

var enemies = {}

var enemy = preload("res://Scenes/Enemy.tscn")

func _ready():
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
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
	
	var payload =  JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8())
	print(payload.result)
	
	if payload.result.has("assignid"):
		myID = payload.result["assignid"]
		data["id"] = myID
		
#	if payload.result.has("id"):
#		var payload_id = payload.result["id"]	
#		# Estamos comparando com 0 aki, porque antes da primeira resposta, o ID é 0
#		if payload_id != myID && payload_id != 0 && !enemies.has(payload_id):
#			print(payload.result)
#			var enemy_instance = enemy.instance()
#			enemies[payload_id] = enemy_instance
#			add_child(enemy_instance)
#		elif enemies.has(payload_id) && payload_id != myID:
#			enemies[payload_id].position = Vector2(payload.result["x"], payload.result["y"])

	if payload.result.has("id"):
		var payload_id = payload.result["id"]	
		

func _process(delta):
	send_player_position()
	

func send_player_position():
	data["x"] = $Player.position.x
	data["y"] = $Player.position.y
	ws.get_peer(1).put_packet(JSON.print(data).to_utf8())
	ws.poll()
