class_name BloodStrainsComponent
extends Node3D

@export var _blood_stain_sprites : Array[Texture]
@export var _decal_scene : PackedScene

@onready var _spawn_stain_cd : Timer = $SpawnStainCd
@onready var _raycast : RayCast3D = $RayCast3D


func start_it(flag: bool):
	if flag:
		_spawn_stain_cd.start()
	else:
		_spawn_stain_cd.stop()

func _ready() -> void:
	_spawn_stain_cd.timeout.connect(_spawn_stain)


func split_alot():
	if (not _raycast.is_colliding()):
		return

	#print_debug(_raycast.get_collision_point())
	for i in range(20):
		
		var decal: DecalCompatibility = _decal_scene.instantiate() as DecalCompatibility
		decal.texture = _blood_stain_sprites[randi() % _blood_stain_sprites.size()]
		decal.rotate_y(randi() % 360)
		var collider_node = _raycast.get_collider() as Node
		collider_node.add_child(decal)
		decal.global_position = _raycast.get_collision_point()
		decal.global_position += Vector3(randf() * 2 - 1 - 0.5, 0, randf() * 2 - 1)


func _spawn_stain():
	if (not _raycast.is_colliding()):
		return

	#print_debug(_raycast.get_collision_point())

	var decal: DecalCompatibility = _decal_scene.instantiate() as DecalCompatibility
	decal.texture = _blood_stain_sprites[randi() % _blood_stain_sprites.size()]
	decal.rotate_y(randi() % 360)
	var collider_node = _raycast.get_collider() as Node
	collider_node.add_child(decal)
	decal.global_position = _raycast.get_collision_point()
	if _raycast.get_collision_point().y <= 0.1:
		decal.global_position.y -= 0.3
	
	#print()
	
