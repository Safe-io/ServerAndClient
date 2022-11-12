extends Area2D

var direction = Vector2.ZERO

var speed = 20

func _ready():
	$Lifetime.connect("timeout", self, "on_timeout")

func _physics_process(_delta: float)-> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(_direction):
	self.direction = _direction
	rotation = direction.angle()

func on_timeout():
	pass
	#self.queue_free()



func _on_Area2D_area_entered(area):
	pass
	#queue_free()
