extends PlayableCharacter

var peashooter_bullet = preload("res://Scenes/Bullet/PeashooterBullet.tscn")

onready var end_of_the_hand = $EndOfTheHand

onready var PlayerHand = $PlayerHand

var is_player : bool

var GemidoHit2

func _ready():
	initialize_main_node()
	initialize_allies_manager()
	movement_speed = 500.0

func _physics_process(_delta):
	if last_rotation != rotation_degrees:
		last_rotation = rotation_degrees
		MainNode.update_player_rotation()

	get_input()
	velocity = move_and_slide(velocity)
	if last_movement_direction != movement_direction:
		last_movement_direction = movement_direction
		MainNode.update_player_position()
		MainNode.update_player_movement_direction()
			

		
		
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
		movement_direction.x = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		movement_direction.x = -1
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
		movement_direction.y = 1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
		movement_direction.y = -1
#################################################
	if Input.is_action_just_released("ui_right"):
		movement_direction.x = 0
	if Input.is_action_just_released("ui_left"):
		movement_direction.x = 0
	if Input.is_action_just_released("ui_down"):
		movement_direction.y = 0
	if Input.is_action_just_released("ui_up"):
		movement_direction.y = 0
		
		
	velocity = velocity.normalized() * movement_speed
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

func is_player():
	return id == MainNode.player_id
