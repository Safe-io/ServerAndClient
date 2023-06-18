extends Actor

class_name PlayableCharacter

func update_velocity():
	velocity = movement_direction.normalized() * movement_speed
