class_name InputComponent
extends Node

signal jump_pressed(flag: bool)
signal movement_pressed(flag: bool)

@export var side_movement_deadzone : float = 0.2

var side_movement_raw : float
var side_movement : int :
	get:
		if (abs(side_movement_raw) > 0.2):
			return 1 if side_movement_raw > 0 else -1
		else:
			return 0
#var crouch : float = 0

func _physics_process(__delta):
	side_movement_raw = Input.get_axis("move_left", "move_right")
#	crouch = Input.is_action_pressed("crouch")

	if (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		movement_pressed.emit(true)
	if (Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")):
		movement_pressed.emit(false)
	
	if (Input.is_action_just_pressed("jump")):
		jump_pressed.emit(true)
		
	if (Input.is_action_just_released("jump")):
		jump_pressed.emit(false)
