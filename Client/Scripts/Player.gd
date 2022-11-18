extends KinematicBody2D

export (int) var speed = 200

var peashooter_bullet = preload("res://Scenes/PeashooterBullet.tscn")

onready var end_of_the_hand = $EndOfTheHand

onready var MainNode = get_tree().root.get_child(0)

var velocity = Vector2()

var AlliesManager

var is_shooting: bool 
onready var PlayerHand = $PlayerHand
var id : String

func _ready():
	AlliesManager = MainNode.get_child(1)


func _physics_process(_delta):
	if id == MainNode.myID:
		get_input()
		velocity = move_and_slide(velocity)

func get_input():

	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		MainNode.send_player_position()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		MainNode.send_player_position()
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		MainNode.send_player_position()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		MainNode.send_player_position()

	velocity = velocity.normalized() * speed
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot_1"):
		if !is_shooting:
			is_shooting = true
			MainNode.send_player_is_shooting(is_shooting)

	if Input.is_action_just_released("shoot_1"):
		if is_shooting:
			is_shooting = false
			MainNode.send_player_is_shooting(is_shooting)

	

