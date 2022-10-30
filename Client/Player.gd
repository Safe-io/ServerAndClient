extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

var mainNode

func _ready():
	pass
	
func get_input():
	get_tree().root.get_child(0).send_player_position()

	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
