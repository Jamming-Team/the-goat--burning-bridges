class_name MainGameLoop
extends Node3D

#@export var obstacle_placer : ObstaclePlacer
#@export var road_maker : RoadMaker
@export var road_scene : PackedScene
@export var road_speed : float = 2.0
@export var roads_array : Array
@export var player_scene : PackedScene
@export var blood_stains_controller : BloodStrainsController
#@export var drone_slots : Node3D
#@export var drone_scene : PackedScene

var queue : Array[RoadPiece] = []
var cur_road : RoadPiece:
	get:
		return queue[_cur_road_ind-1] as RoadPiece
var max_queue_size = 10
var min_behind : int = 2
var _front_position : float
var _cur_road_ind : int
var _cur_road_remaining_length : float
var _cur_row_ind : int
var _player : Node3D
#var _tween : Tween
var _physical_layers = []
var _cur_player_position_type : Constants.PositionType
#var _free_drone_slots_array : Array

#@onready var spawn_drone_timer : Timer = $SpawnDroneTimer
@onready var _roads_structure : Node3D = $RoadsStructure
@onready var _input_controller : InputController = %InputController
@onready var _move_cooldown_timer : Timer = $MoveCooldown
@onready var _pre_jump_timer : Timer = $PreJumpTimer
@onready var _health : Health = $Health


# Add an item to the queue if it has not reached its maximum capacity
func add_to_queue(item):
	if len(queue) < max_queue_size:
		queue.push_back(item)

# Removes the front item from the queue and returns whether or not the queue was empty
func finish_queue_front():
	queue[0].queue_free()
	return queue.pop_front()


# Called when the node enters the scene tree for the first time.
func _ready():
	#print (road_maker.road_width)
	#obstacle_placer.place_obstacles(road_maker._cells_matrix, road_maker.road_width, road_maker.road_length)
	init_road()
	_player = player_scene.instantiate() as Node3D
	_player.position = Vector3(0, 0, (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_cur_row_ind))
	add_child(_player)
	_player.add_to_group("Player")
	print(_player.get_groups())
#	_tween = create_tween()
	_cur_player_position_type = Constants.PositionType.MIDDLE
	_initial_player_y = _player.position.y
	_input_controller.jump_pressed.connect(process_jump)
	
	blood_stains_controller.supply(_player, self)
	
#	for drone_slot in drone_slots.get_children():
#		_free_drone_slots_array.append(drone_slot)


var move_for_value : float

func _process(delta):
	if (_cur_road_remaining_length > 0.0):
		move_for_value = road_speed * delta
		for road : RoadPiece in queue:
			road.position += Vector3(-move_for_value, 0.0, 0.0)
		_cur_road_remaining_length -= move_for_value
		_front_position -= move_for_value
	else:
		do_update_structure()
		_cur_road_remaining_length = (queue[_cur_road_ind] as RoadPiece).road_length + _cur_road_remaining_length
	


@export var jump_height : float = 2
@export var jump_length : float = 4
var _initial_player_y : float
var _cur_x : float
var _cur_k : float
func process_jump(call_type : int = 0):
	if call_type == 0 and (_player as Player).position.y == 0:
		_cur_x = -jump_length / 2
		_cur_player_position_type = Constants.PositionType.HIGH
		#print("test2")
		_cur_k = jump_height / (jump_length / 2 * jump_length / 2)
		#print("k: " + str(_cur_k))
		return
	#print("test")
	
	if (call_type == 0):
		_pre_jump_timer.start();
	
	(_player as Player).position.y =  -(_cur_x * _cur_x) * _cur_k + jump_height
	_cur_x += move_for_value
	#print(move_for_value)
	#print(_cur_x)
	
	if (_cur_x > jump_length / 2):
		_cur_player_position_type = Constants.PositionType.MIDDLE


func _physics_process(delta):
	var cur_side_mov_dir = _input_controller.side_movement
	if (cur_side_mov_dir != 0 && _move_cooldown_timer.is_stopped()):
		#print(str(cur_side_mov_dir) + str((queue[_cur_road_ind] as RoadPiece).road_width - 1) + " " + str(_cur_row_ind + cur_side_mov_dir))
		_cur_row_ind = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		#var a = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		var new_row_coords = (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_cur_row_ind)
		#print("row ind: " + str(_cur_row_ind) + ", row coords: " + str(new_row_coords))
		#print("road ind: " + str(_cur_road_ind))
		var tween: Tween = create_tween()
		tween.tween_method(func(x): _player.position.z = x, _player.position.z, new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
		tween.tween_method(func(x): _player.position.z = x, new_row_coords + 0.2 * cur_side_mov_dir, new_row_coords, 0.05)
#		tween.tween_property(_player, "position.x", new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
#		tween.tween_property(_player, "position.x", new_row_coords, 0.05)
		#tween.interpolate_value(_player.position, Vector3(0, 0, new_row_coords - _player.position.z), 0, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
		#_player.position = Vector3(0, 0, new_row_coords)
		_move_cooldown_timer.start()
	
	if (!_cur_player_position_type == Constants.PositionType.HIGH):
		if (_input_controller.crouch == 1):
			_player.position.y = _initial_player_y - 0.5
			_cur_player_position_type = Constants.PositionType.LOW
		else:
			_player.position.y = _initial_player_y
			_cur_player_position_type = Constants.PositionType.MIDDLE
	else:
		#print_debug("test3")
		process_jump(1)
	
	
	if (queue[_cur_road_ind-1] as RoadPiece).current_obstacle != null && _cur_player_position_type == (queue[_cur_road_ind-1] as RoadPiece).current_obstacle.position_type:
		(queue[_cur_road_ind-1] as RoadPiece).destroy_current_obstacle()
		_health.take_hit_damage()
	if cur_road.current_bottle != null && _cur_player_position_type == cur_road.current_bottle.position_type:
		cur_road.destroy_current_bottle()
		_health.take_bottle_heal()
		
		


func init_road():
	_front_position = 0.0
	while (queue.size() < max_queue_size):
		var road_instance = road_scene.instantiate() as RoadPiece
		_roads_structure.add_child(road_instance)
		road_instance.position = Vector3(_front_position, 0.0, 0.0)
		_front_position += road_instance.road_length
		#print((road_instance.cells_matrix[Vector2(1,1)] as Cell).position)
		add_to_queue(road_instance)
		
	_cur_road_ind = 0
	while (_cur_road_ind < min_behind):
		var move_for_length = (queue[_cur_road_ind] as RoadPiece).road_length
		for road : RoadPiece in queue:
			road.position += Vector3(-move_for_length, 0.0, 0.0)
		_front_position += -move_for_length
		_cur_road_ind += 1
	_cur_road_remaining_length = 0.0
	_cur_row_ind = (queue[_cur_road_ind] as RoadPiece).road_width / 2

func do_update_structure():
	finish_queue_front()
	var road_instance = road_scene.instantiate() as RoadPiece
	_roads_structure.add_child(road_instance)
	road_instance.fill_cells_matrix()
	road_instance.position = Vector3(_front_position, 0.0, 0.0)
	_front_position += road_instance.road_length
	#print_debug((road_instance.cells_matrix[Vector2(1,1)] as Cell).position)
	#(road_instance.obstacle_placer as ObstaclePlacer).place_obstacles(road_instance.cells_matrix, road_instance.road_width, road_instance.road_length_in_cells)
	add_to_queue(road_instance)




#func _on_spawn_drone_timer_timeout():
	#var new_waiting_time = randf_range(2, 3)
	#spawn_drone_timer.wait_time = new_waiting_time
	#spawn_drone_timer.start()
	#
	#if (_free_drone_slots_array.size() == 0):
		#return
	#
	#print_debug("_free_drone_slots_array.size(): " + str(_free_drone_slots_array.size()))
	#var rand_drone_slot = _free_drone_slots_array[randi_range(0,_free_drone_slots_array.size() - 1)] as DroneSlot
	#rand_drone_slot.spawn_drone(drone_scene)
	#_free_drone_slots_array.erase(rand_drone_slot)
