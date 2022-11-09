extends Area2D

export (int) var speed = 15

var direction = Vector2.ZERO


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
	self.queue_free()

