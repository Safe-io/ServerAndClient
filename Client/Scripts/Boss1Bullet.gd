extends AnimatedSprite

var speed = 400

func _process(delta):

	position += transform.x * speed * delta

	

func _on_KillTimer_timeout():
	queue_free()
	
func _ready():
	self.play("charge_anim")

func _on_Sprite_animation_finished():
	self.set_frame(3)
