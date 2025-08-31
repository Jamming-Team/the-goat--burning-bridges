class_name PlayerController
extends Node3D

#@export var player_graphics : Node3D
#@export_flags_3d_physics var _collision_mask : int

var is_grounded : bool:
	get:
		return position.y == initial_player_y

var initial_player_y : float
var cur_player_position_type : Constants.PositionType
var cur_row_ind : int


@onready var health_component : HealthComponent = $HealthComponent
@onready var movement_component : MovementComponent = $MovementComponent
@onready var input_component : InputComponent = $InputComponent
@onready var blood_stains_component : BloodStrainsComponent = $BloodStrainsComponent


func start_it(flag: bool):
	if flag:
		blood_stains_component.start_it(true)
		health_component.start_it(true)
	else:
		blood_stains_component.start_it(false)
		health_component.start_it(false)
		
		

func _ready() -> void:
	initial_player_y = position.y
	movement_component.init(self, input_component)

#func _process(__delta: float) -> void:
	#print_debug(position)
