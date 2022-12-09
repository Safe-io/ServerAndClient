extends Boss

#set_variables(fire_rate, bullet_speed, bullet_rotation_degrees_per_frame, rotation_speed)     
var first_phase_node
#Bullet speed altera o ramanho dos balões
#Rotações múltiplas de 1.5 não alteram o padrão
#A quantidade de balões é definida por (bullet_rotation / rotation)
func _ready():
	start_first_phase()

func start_first_phase():
	first_phase_node = Node2D.new()
	add_child(first_phase_node)
	first_phase_node.set_name ("FirstPhase")
	$Shoot1_1.start()
func start_second_phase():
	print("Starting second phase")
func start_third_phase():
	print("Starting third phase")
func start_last_phase():
	print("Starting fourth phase")

func _on_Shoot1_1_timeout():
	current_rotator = instantiate_rotator()
	current_rotator.set_variables(20, 500, 2, 1)
	first_phase_node.add_child(current_rotator)

	$Shoot1_2.start()

func _on_Shoot1_2_timeout():
	current_rotator = instantiate_rotator()
	current_rotator.set_variables(10,1000, 4, 1)
	first_phase_node.add_child(current_rotator)

	$Shoot1_3.start()


func _on_Shoot1_3_timeout():
	current_rotator = instantiate_rotator()
	current_rotator.set_variables(10,500, 2, 2)
	current_rotator.rotation = 30
	first_phase_node.add_child(current_rotator)
	
	
