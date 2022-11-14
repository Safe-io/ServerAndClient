extends Area2D

var direction = Vector2.ZERO

var speed: float = 400.0

var travelled_distance: float = 0

var max_range: float = 0

var is_ready: bool = true

func _physics_process(_delta: float)-> void:
	
	var distance_per_frame := speed * _delta
	var motion := transform.x * distance_per_frame
	position += motion
	travelled_distance += distance_per_frame
	if travelled_distance >= max_range:
		set_process(false)
		hide()
		is_ready = true
func set_direction(_direction):
	self.direction = _direction
	rotation = direction.angle()

func _on_Area2D_area_entered(area):
	pass
	#queue_free()
