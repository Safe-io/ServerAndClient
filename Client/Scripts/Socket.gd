extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"

var AlliesManager
var Boss1
var Player

var myID : String
var frame_data : Dictionary
var damage_points_dealed_in_the_frame : int = 0

func _ready():
	
	$Label.set_as_toplevel(true)
	
	AlliesManager = $AlliesManager
	Boss1 = $Boss
	
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
		print(payload.result["enemies"]["1"]["life"])
		Boss1.update_boss_health_points(int(payload.result["enemies"]["1"]["life"]))
		AlliesManager.update_allies_status(payload.result["players"], myID)


func increase_damage_points_dealed_in_the_frame():
	damage_points_dealed_in_the_frame += 1

func _process(delta):
	ws.poll()
	send_full_data()
	
	$Label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Label2.text = "Memory Static: " + str(Performance.get_monitor(Performance.MEMORY_STATIC))

func update_damage_dealed():
	frame_data["damage"] = {1 : damage_points_dealed_in_the_frame}	
	damage_points_dealed_in_the_frame = 0

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
	update_damage_dealed()
	ws.get_peer(1).put_packet(JSON.print(frame_data).to_utf8())


