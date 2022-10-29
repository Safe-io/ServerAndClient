extends Node

var ws = WebSocketClient.new()
var URL = "ws://127.0.0.1:3000/"
var myID

var conectadoAoServidor = false

func _ready():
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	var err = ws.connect_to_url(URL)
	if err != OK:
		print("Connection Refused")
		set_process(false)
		
func _closed(was_clean = false):
	print("Connection Closed")

func _connected(proto = ""):
	conectadoAoServidor = true
	print("Connected To Server")
	
	
	
func _on_data():
	
	var response =  JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result

	print(response)


	
func _process(delta):
	ws.poll()
	if(conectadoAoServidor == false):
		pass
	
	if Input.is_action_just_pressed("ui_up"):
		var payload = JSON.print({"msgg" : "Mensagem do Godot"})
		ws.get_peer(1).put_packet((payload).to_utf8())
		

	
