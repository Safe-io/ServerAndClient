extends Node2D

class_name Boss

var current_phase:int = 1

func ChangePhase():
	current_phase  += 1
	
	if(current_phase == 1):
		start_first_phase()
	if(current_phase == 2):
		start_second_phase()
	if(current_phase == 3):
		start_third_phase()
	if(current_phase == 4):
		start_fourth_phase()

onready var MainNode = get_tree().root.get_child(0)

var max_health: float = 2000
var health_points : float = 2000.0

var fire_rate
var bullet_speed
var bullet_rotation_degrees_per_frame

var current_rotator
var Rotators = []
onready var hp_bar = $HPBar
onready var HurtSound = $HitSound

var BossCannonScene = preload("res://Scenes/Boss/BossCannon.tscn")

var RotatorScene  = preload("res://Scenes/Boss/Rotator.tscn")

func update_boss_health_points(curent_health_points: int):
	health_points = curent_health_points

func _on_Area2D_area_entered(area):
	area.turn_bullet_off()
	HurtSound.play()

	if(area.is_player_bullet):
		MainNode.increase_damage_points_dealed_in_the_frame()
	hp_bar.value = (health_points/max_health) * 100

func start_first_phase():
	print("Starting first phase")
func start_second_phase():
	print("Starting first phase")
func start_third_phase():
	print("Starting first phase")
func start_fourth_phase():
	print("Starting first phase")

func instantiate_rotator():
	current_rotator = RotatorScene.instance()
	Rotators.append(current_rotator)
	return current_rotator
