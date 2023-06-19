extends Node

var ws = WebSocketClient.new()
var URL = "wss://bossle.online/ws"
var connected_to_server:bool
	
var AlliesManager
var Boss1
var Player
var target_position: Vector2
		
var player_id : String
var frame_data : Dictionary
var damage_points_dealed_in_the_frame : int = 0

const ENEMY_ID : int = 1

func _ready():
	if OS.has_feature("editor"):
		URL = "ws://127.0.0.1:3000/"
		
	AlliesManager = $AlliesManager
	Boss1 = $Boss
	
	var err = ws.connect_to_url(URL)
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")

	
	if err != OK:
		print("Connection Refused")
		connected_to_server = false
		set_process(false)
		
func _closed(_was_clean = false):
	print("Connection Closed")
	connected_to_server = false

func _connected(id):
	print("Conectou ao Servidor")
	connected_to_server = true

func _on_data():
	var payload = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8())
	if payload.result == null:
		return

	if payload.result.has("assignid"):
		player_id = String(payload.result["assignid"]) 

		print("My ID was assigned: " + player_id)
		AlliesManager.create_player(player_id)
		Player = $PlayerParent.get_child(0)
		update_player_position()
	else:
		
		# LEMBRE-SE QUE ENEMY ID EH HARD CODED, JA QUE AINDA NAO IMPLEMENTAMOS ENEMIES MANAGER
		Boss1.update_boss_health_points(int(payload.result["enemies"][String(ENEMY_ID)]["life"]))
		AlliesManager.update_allies_status(payload.result["players"], player_id)
		var pos = payload.result["players"][player_id]["pos"]
		

		target_position.x = pos[0]
		target_position.y = pos[1]




func increase_damage_points_dealed_in_the_frame():
	damage_points_dealed_in_the_frame += 1

func _process(delta):

	
	ws.poll()
	if connected_to_server && player_id && !Player.is_afk:
		print(delta)

		Player.global_position = Player.global_position.linear_interpolate(target_position, delta)
		send_full_data()
	
func update_damage_dealed():
	# LEMBRE-SE QUE ENEMY ID EH HARD CODED, JA QUE AINDA NAO IMPLEMENTAMOS ENEMIES MANAGER
	frame_data["damage"] = {ENEMY_ID : damage_points_dealed_in_the_frame}	
	damage_points_dealed_in_the_frame = 0

func update_player_movement_direction():
	frame_data["motion"] = [Player.movement_direction.x, Player.movement_direction.y]
	frame_data["type"] = "movement"
	
func update_player_position():
	frame_data["pos"] = [Player.global_position.x, Player.global_position.y];

	
func update_player_rotation():
	var rotation_data : int = int(Player.rotation_degrees)
	frame_data["r"] = rotation_data

func update_player_is_shooting(is_shooting: bool):
	frame_data["s"] = int(is_shooting) 
	
func send_full_data():
	print("Sent: " , frame_data)
	ws.get_peer(1).put_packet(JSON.print(frame_data).to_utf8())

