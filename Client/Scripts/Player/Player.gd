extends KinematicBody2D

export (int) var speed = 200

var peashooter_bullet = preload("res://Scenes/Bullet/PeashooterBullet.tscn")

onready var end_of_the_hand = $EndOfTheHand

onready var MainNode = get_tree().root.get_child(0)

var velocity = Vector2()

var health_points = 10

var AlliesManager
var last_rotation
var last_direction
var direction := Vector2(0,0)

var is_shooting: bool 
onready var PlayerHand = $PlayerHand
var id : String
var is_player : bool

var GemidoHit2

func _ready():
	if id == MainNode.myID:
		is_player = true
	else:
		is_player = false
	AlliesManager = MainNode.get_child(1)
	last_rotation = rotation_degrees
	GemidoHit2 = $GemidoHit2

func _physics_process(_delta):
	if last_rotation != rotation_degrees:
		last_rotation = rotation_degrees
		MainNode.update_player_rotation()
		
	if id == MainNode.myID:
		get_input()
		velocity = move_and_slide(velocity)
		if last_direction != direction:
			last_direction = direction
			MainNode.update_player_position()
			MainNode.update_player_direction()
			
	else:
		velocity = move_and_slide(direction.normalized() * speed)
		


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		direction.x = -1
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
		direction.y = 1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
		direction.y = -1
#################################################
	if Input.is_action_just_released("ui_right"):
		direction.x = 0
	if Input.is_action_just_released("ui_left"):
		direction.x = 0
	if Input.is_action_just_released("ui_down"):
		direction.y = 0
	if Input.is_action_just_released("ui_up"):
		direction.y = 0
		
		
	velocity = velocity.normalized() * speed
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot_1"):
		if !is_shooting:
			is_shooting = true
			MainNode.update_player_is_shooting(is_shooting)

	if Input.is_action_just_released("shoot_1"):
		if is_shooting:
			is_shooting = false
			MainNode.update_player_is_shooting(is_shooting)
	
func _on_Area2D_area_entered(area):
	print("colisao pelo player")

func take_damage():
	print("tomou dano")
	if health_points <=0:
		pass
	health_points = health_points -1
	GemidoHit2.play()
