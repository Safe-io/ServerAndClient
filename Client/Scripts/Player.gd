extends KinematicBody2D

export (int) var speed = 200

var peashooter_bullet = preload("res://Scenes/PeashooterBullet.tscn")

onready var end_of_the_hand = $EndOfTheHand

onready var MainNode = get_tree().root.get_child(0)

var velocity = Vector2()

var AlliesManager

var is_shooting: bool = false

func _ready():
	AlliesManager = MainNode.get_child(1)

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
#
func shoot(position: Vector2, rotation_degrees: float, id: int = MainNode.myID):
	var bullet_instance = peashooter_bullet.instance()
	MainNode.add_child(bullet_instance)
	if(id == MainNode.myID):
		bullet_instance.global_position = $EndOfTheHand.global_position
		var bullet_target = $EndOfTheHand.global_position
		var direction_to_mouse = position.direction_to(bullet_target).normalized()
		bullet_instance.set_direction(direction_to_mouse)
	else:
		var ally = AlliesManager.allies[str(id)]
		var ally_end_of_the_hand_position = ally.get_node("EndOfHand").global_position
		print(ally.get_node("EndOfHand"))
		bullet_instance.global_position = ally_end_of_the_hand_position
		var bullet_target = ally_end_of_the_hand_position
		var direction_of_bullet = ally.position.direction_to(bullet_target).normalized()
		bullet_instance.set_direction(direction_of_bullet)
	
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
		shoot(position, rotation_degrees, 1)
		if !is_shooting:
			is_shooting = true
			MainNode.send_player_is_shooting(is_shooting)

	if Input.is_action_just_released("shoot_1"):
		if is_shooting:
			is_shooting = false
			MainNode.send_player_is_shooting(is_shooting)

	

