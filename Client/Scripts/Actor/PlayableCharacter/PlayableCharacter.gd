extends Actor

class_name PlayableCharacter

func update_velocity():
	velocity = movement_direction.normalized().rotated(deg2rad(rotation_degrees + 90)) * movement_speed
