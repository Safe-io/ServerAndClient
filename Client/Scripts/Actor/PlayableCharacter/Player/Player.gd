extends PlayableCharacter

var peashooter_bullet = preload("res://Scenes/Bullet/PeashooterBullet.tscn")

var camera
var GemidoHit2
var PlayerHand
var afk_timer
var collision
var rotate_speed = 1.2
var acceleration :float = 100
var current_speed : float = 250
var is_stopped: bool = true
var is_afk:bool = false

func _ready():
	camera = $Camera2D
	afk_timer = $player_is_active
	initialize_main_node()
	initialize_allies_manager()
	initialize_boss()
	PlayerHand = $PlayerHand
	GemidoHit2 = $GemidoHit2
	movement_speed = 200


func _physics_process(_delta):

	if last_rotation != rotation_degrees:
		last_rotation = rotation_degrees
		MainNode.update_player_rotation()

	get_input(_delta)

	velocity = move_and_slide(velocity)
	if collision:
		print("Colidiu com", collision.collider.name)
	
	if (movement_direction.length() != 0):
		is_stopped = false
		is_afk = false
	else:
		is_stopped = true
	if last_movement_direction != movement_direction:
		last_movement_direction = movement_direction
		is_afk = false
		afk_timer.start(afk_timer.wait_time)
		afk_timer.stop()

	else:
		if afk_timer.is_stopped():
			afk_timer.start()
			
	MainNode.update_player_movement_direction()

func get_input(delta):
	velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		movement_direction.x = 1
	if Input.is_action_pressed("ui_left"):
		movement_direction.x = -1
	if Input.is_action_pressed("ui_down"):
		movement_direction.y = 1
	if Input.is_action_pressed("ui_up"):
		movement_direction.y = -1
#################################################
	if Input.is_action_just_released("ui_right"):
		movement_direction.x = 0
		MainNode.update_player_movement_direction()

	if Input.is_action_just_released("ui_left"):
		movement_direction.x = 0
		MainNode.update_player_movement_direction()

	if Input.is_action_just_released("ui_down"):
		movement_direction.y = 0
		MainNode.update_player_movement_direction()

	if Input.is_action_just_released("ui_up"):
		movement_direction.y = 0
		MainNode.update_player_movement_direction()

	
	current_speed = lerp(current_speed, movement_speed, acceleration * delta)
	global_position += movement_direction * current_speed * delta
	
	look_at(get_global_mouse_position())
	#update_velocity()

	if Input.is_action_pressed("shoot_1"):
		if !is_shooting:
			is_shooting = true
			PlayerHand.is_shooting = true
			MainNode.update_player_is_shooting(is_shooting)

	if Input.is_action_just_released("shoot_1"):
		if is_shooting:
			is_shooting = false
			PlayerHand.is_shooting = false
			MainNode.update_player_is_shooting(is_shooting)
	
func _on_PlayerArea2D_area_entered(area):
	#GemidoHit2.play()
	if area.name == "BossCollider":
		return
	area.turn_bullet_off()
	
func _on_player_is_active_timeout():
	is_afk = true
	print("Disconnected for being AFK")
