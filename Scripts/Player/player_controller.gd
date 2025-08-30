class_name PlayerController
extends Node3D

#@export var player_graphics : Node3D
#@export_flags_3d_physics var _collision_mask : int

@onready var health_component : HealthComponent = $HealthComponent

#func _process(__delta: float) -> void:
	#print_debug(position)
