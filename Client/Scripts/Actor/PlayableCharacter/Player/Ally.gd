extends PlayableCharacter

var peashooter_bullet = preload("res://Scenes/Bullet/PeashooterBullet.tscn")

func _ready():
	movement_speed = 500.0
func _physics_process(delta):
	velocity = move_and_slide(movement_direction.normalized() * movement_speed)
	print(movement_direction)
