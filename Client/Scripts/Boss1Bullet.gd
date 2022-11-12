extends Sprite

var speed = 200

func _process(delta):
	position += transform.x * speed * delta
	



func _on_KillTimer_timeout():
	queue_free()
