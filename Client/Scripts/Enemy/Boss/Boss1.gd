extends Boss

#set_variables(fire_rate, bullet_speed, bullet_rotation_degrees_per_frame, rotation_speed)     
var current_phase_node
var max_hp = 1000
var phases_rotators_settings = [
	[
		{
			fire_rate = 20,
			bullet_speed = 600,
			bullet_rotation_degrees_per_frame = 3,
			rotation_speed = 1
		},
		{
			fire_rate = 10,
			bullet_speed = 1000,
			bullet_rotation_degrees_per_frame = 1.5,
			rotation_speed = 2
		},
		{
			fire_rate = 2.5,
			bullet_speed = 600,
			bullet_rotation_degrees_per_frame = 1.5,
			rotation_speed = 2
		}
	],
	[
		{
			fire_rate = 5,
			bullet_speed = 600,
			bullet_rotation_degrees_per_frame = 3,
			rotation_speed = 1
		},
		{
			fire_rate = 10,
			bullet_speed = 500,
			bullet_rotation_degrees_per_frame = 1.5,
			rotation_speed = 1
		},
		{
			fire_rate = 15,
			bullet_speed = 600,
			bullet_rotation_degrees_per_frame = 1.5,
			rotation_speed = 2
		}
	]
];
#Bullet speed altera o ramanho dos balões
#Rotações múltiplas de 1.5 não alteram o padrão
#A quantidade de balões é definida por (bullet_rotation / rotation)
func _ready():
	start_first_phase()

func start_first_phase():
	current_phase_node = Node2D.new()
	add_child(current_phase_node)
	current_phase_node.set_name ("FirstPhase")
	$Shoot1_1.start()
func start_second_phase():
	print("Starting second phase")
func start_third_phase():
	print("Starting third phase")
func start_last_phase():
	print("Starting fourth phase")

func _on_Shoot1_1_timeout():
	current_rotator = instantiate_rotator()
	current_rotator.set_variables(phases_rotators_settings[current_phase-1][0].fire_rate, phases_rotators_settings[current_phase-1][0].bullet_speed, phases_rotators_settings[current_phase-1][0].bullet_rotation_degrees_per_frame, phases_rotators_settings[current_phase-1][0].rotation_speed);
	current_phase_node.add_child(current_rotator)

	$Shoot1_2.start()

func _on_Shoot1_2_timeout():
	current_rotator = instantiate_rotator()

	current_rotator.set_variables(phases_rotators_settings[current_phase-1][1].fire_rate, phases_rotators_settings[current_phase-1][1].bullet_speed, phases_rotators_settings[current_phase-1][1].bullet_rotation_degrees_per_frame, phases_rotators_settings[current_phase-1][1].rotation_speed);
	current_phase_node.add_child(current_rotator)

	$Shoot1_3.start()

func _on_Shoot1_3_timeout():
	current_rotator = instantiate_rotator()
	current_rotator.set_variables(phases_rotators_settings[current_phase-1][2].fire_rate, phases_rotators_settings[current_phase-1][2].bullet_speed, phases_rotators_settings[current_phase-1][2].bullet_rotation_degrees_per_frame, phases_rotators_settings[current_phase-1][2].rotation_speed);
	current_phase_node.add_child(current_rotator)
	
func _start_second_phase():
	$FirstPhase.queue_free()
	current_phase_node = Node2D.new()
	add_child(current_phase_node)
	current_phase_node.set_name ("SecondPhase")
	$Shoot1_1.start()

func _on_SecondPhase_timeout():
	ChangePhase();
