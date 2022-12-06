extends Boss

#set_variables(fire_rate, bullet_speed, bullet_rotation_degrees_per_frame)     
var first_phase_node

func start_first_phase():
	first_phase_node = Node2D.new()
	add_child(first_phase_node)
	first_phase_node.set_name ("FirstPhase")
	current_rotator = instantiate_rotator()
	first_phase_node.add_child(current_rotator)
	current_rotator.set_variables(10, 500, 1.5)

func start_second_phase():
	print("Starting second phase")
func start_third_phase():
	print("Starting third phase")
func start_last_phase():
	print("Starting fourth phase")

func _on_StartFirstPhase_timeout():
	start_first_phase()
