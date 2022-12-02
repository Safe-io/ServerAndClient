extends Area2D

class_name Bullet

var movement_speed: float = 500.0
var max_range: float = 3000
var movement_direction : Vector2

var travelled_distance: float = 0
var distance_per_frame: float
var is_player_bullet: bool
var motion : Vector2

var rotation_degrees_per_frame: float = 1.61803398875
func turn_bullet_off():
	if self.is_visible():
		self.hide()
		self.set_physics_process(false)

func turn_bullet_on():
	travelled_distance = 0
	if self.is_visible() == false:
		self.set_visible(true)
		self.set_physics_process(true)

func _physics_process(_delta: float)-> void:
	if movement_direction:
		move_bullet(_delta)
		increase_travelled_distance()
		if travelled_distance >= max_range:
			turn_bullet_off()

func set_direction(_direction):
	turn_bullet_on()
	self.movement_direction = _direction
	rotation = movement_direction.angle()
	
func move_bullet(_delta):
	distance_per_frame = movement_speed * _delta
	motion = transform.x * distance_per_frame
	position += motion

func increase_travelled_distance():
	travelled_distance += distance_per_frame

