extends Area2D

var direction = Vector2.ZERO

var speed: float = 400.0

var travelled_distance: float = 0

var max_range: float = 0



func _physics_process(_delta: float)-> void:
	if direction:
		var distance_per_frame := speed * _delta
		var motion := transform.x * distance_per_frame
		position += motion
		travelled_distance += distance_per_frame
		if travelled_distance >= max_range:
			turn_bullet_off(self)
			

			
func set_direction(_direction):
	travelled_distance = 0
	self.direction = _direction
	rotation = direction.angle()
	turn_bullet_on(self)

func _on_Area2D_area_entered(area):
	pass
	turn_bullet_off(self)
	#queue_free()

func turn_bullet_off(bullet):
	if bullet.is_visible():
		bullet.hide()
		bullet.set_physics_process(false)
	
func turn_bullet_on(bullet):
	if bullet.is_visible() == false:
		bullet.set_visible(true)
		bullet.set_physics_process(true)
