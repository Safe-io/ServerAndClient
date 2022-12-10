extends PlayableCharacter

var peashooter_bullet = preload("res://Scenes/Bullet/PeashooterBullet.tscn")

var GemidoHit2
var PlayerHand
var collision
var rotate_speed = 1.2
func _ready():
	initialize_main_node()
	initialize_allies_manager()
	initialize_boss()
	PlayerHand = $PlayerHand
	GemidoHit2 = $GemidoHit2
	movement_speed = 1000.0


func _physics_process(_delta):
	if last_rotation != rotation_degrees:
		last_rotation = rotation_degrees
		MainNode.update_player_rotation()

	get_input(_delta)

	velocity = move_and_slide(velocity)
	if collision:
		print("Colidiu com", collision.collider.name)
	if last_movement_direction != movement_direction:
		last_movement_direction = movement_direction
		MainNode.update_player_position()
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
	if Input.is_action_just_released("ui_left"):
		movement_direction.x = 0
	if Input.is_action_just_released("ui_down"):
		movement_direction.y = 0
	if Input.is_action_just_released("ui_up"):
		movement_direction.y = 0
		
	smoothly_rotate_to_target(self, Boss, delta)
	update_velocity()
	
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
	
	
func smoothly_rotate_to_target(agent, target, delta):
	var direction_to_target = (target.global_position - global_position)
	var angle_to_target     = transform.x.angle_to(direction_to_target)
	agent.rotate(sign(angle_to_target) * min(delta * rotate_speed, abs(angle_to_target)))

	



func _on_PlayerArea2D_area_entered(area):
	GemidoHit2.play()
	if area.name == "BossCollider":
		return
	area.turn_bullet_off()
