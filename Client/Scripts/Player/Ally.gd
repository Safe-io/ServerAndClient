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
	AlliesManager = MainNode.get_child(1)
	last_rotation = rotation_degrees
	GemidoHit2 = $GemidoHit2

func _physics_process(_delta):
	velocity = move_and_slide(direction.normalized() * speed)
		

	
func _on_Area2D_area_entered(area):
	print("colisao pelo player")

func take_damage():
	print("tomou dano")
	if health_points <=0:
		pass
	health_points = health_points -1
	GemidoHit2.play()


