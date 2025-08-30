class_name BloodStrainsController
extends Node

@export var _blood_stain_sprites : Array[Texture]
@export var _decal_scene : PackedScene

var _player : Player
var _main_loop : MainGameLoop
@onready var _spawn_stain_cd : Timer = $SpawnStainCd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_stain_cd.timeout.connect(_spawn_stain)
	pass # Replace with function body.

func supply(player : Player, main_loop : MainGameLoop):
	_player = player
	_main_loop = main_loop

func _spawn_stain():
	#print(1)
	if _player and _main_loop:
		var scene_instance: Decal = _decal_scene.instantiate() as Decal
		scene_instance.texture_albedo = _blood_stain_sprites[randi() % _blood_stain_sprites.size()]
		scene_instance.rotate_y(randi() % 360)
		_main_loop.cur_road.add_child(scene_instance)
		scene_instance.global_position = _player.hit_position 
		#scene_instance.reparent(_main_loop.cur_road)
	
		
