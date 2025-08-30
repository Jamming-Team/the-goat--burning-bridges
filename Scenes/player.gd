class_name Player
extends Node3D

#@export var player_graphics : Node3D
@export_flags_3d_physics var _collision_mask : int

var hit_position : Vector3
@onready var raycast : RayCast3D = $RayCast3D

func _physics_process(delta: float) -> void:
	#var space_state = get_world_3d().direct_space_state
#
		## use global coordinates, not local to node
	#var query = PhysicsRayQueryParameters3D.create(position + Vector3(0, 0.5, 0), position + Vector3(0, -10, 0), _collision_mask)
	#var result = space_state.intersect_ray(query)
	if raycast.is_colliding():
		#print(1)
		hit_position = raycast.get_collision_point()
		#print_debug(result.position)
		#hit_position = result.position
