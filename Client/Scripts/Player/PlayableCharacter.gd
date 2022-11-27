extends Actor

class_name Playable_Character

var id : String
var velocity = Vector2()
var health_points : int = 10
var AlliesManager
var last_rotation
var last_direction
var direction := Vector2(0,0)
var is_shooting: bool = false 
onready var PlayerHand = $PlayerHand

func _init(id : String = ""): 
	self.id = id
