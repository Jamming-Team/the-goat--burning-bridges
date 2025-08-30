class_name BloodStrainsComponent
extends Node3D

@export var _blood_stain_sprites : Array[Texture]
@export var _decal_scene : PackedScene

@onready var _spawn_stain_cd : Timer = $SpawnStainCd
@onready var _raycast : RayCast3D = $RayCast3D


func _ready() -> void:
	_spawn_stain_cd.timeout.connect(_spawn_stain)


func _spawn_stain():
	if (not _raycast.is_colliding()):
		return

	print_debug(_raycast.get_collision_point())

	var decal: Decal = _decal_scene.instantiate() as Decal
	decal.texture_albedo = _blood_stain_sprites[randi() % _blood_stain_sprites.size()]
	decal.rotate_y(randi() % 360)
	var collider_node = _raycast.get_collider() as Node
	collider_node.add_child(decal)
	decal.global_position = _raycast.get_collision_point()
	
