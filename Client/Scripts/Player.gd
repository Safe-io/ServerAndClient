extends KinematicBody2D

export (int) var speed = 200

var peashooter_bullet = preload("res://Scenes/PeashooterBullet.tscn")

onready var end_of_the_hand = $EndOfTheHand

onready var MainNode = get_tree().root.get_child(0)

var velocity = Vector2()

var mainNode

func _ready():
	pass
	

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
#
func shoot():
	var bullet_instance = peashooter_bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = end_of_the_hand.global_position
	var bullet_target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(bullet_target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	
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
		shoot()
