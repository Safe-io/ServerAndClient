extends Boss

func _ready():
	ChangePhase()

func start_first_phase():
	current_rotator = RotatorScene.instantiate()
	Rotators.append(current_rotator)
	add_child(current_rotator)
	add_child(current_rotator)
func start_second_phase():
	print("Starting second phase")
func start_third_phase():
	print("Starting third phase")
func start_last_phase():
	print("Starting fourth phase")
