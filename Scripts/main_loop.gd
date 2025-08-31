class_name MainGameLoop
extends Node3D


@export var road_scene : PackedScene
@export var road_speed : float = 2.0
@export var roads_array : Array
@export var player_scene : PackedScene

@export var increase_boxes_per_interval : int = 2
@export var increase_bottles_per_interval : int = 1

@onready var increase_difficulty_interval : Timer = $IncreaseDifficultyInterval


var boxes_to_spawn_modificator : int = 0
var bottles_to_spawn_modificator : int = 0





var queue : Array[RoadPiece] = []
var cur_road : RoadPiece:
	get:
		return queue[_cur_road_ind-1] as RoadPiece
var max_queue_size = 4
var min_behind : int = 2
var _front_position : float
var _cur_road_ind : int
var _cur_road_remaining_length : float
#var _cur_row_ind : int
var _player : PlayerController
#var _tween : Tween
var _physical_layers = []
#var _free_drone_slots_array : Array

var _game_is_in_process : bool


#@onready var spawn_drone_timer : Timer = $SpawnDroneTimer
@onready var _roads_structure : Node3D = $RoadsStructure



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
	_player = player_scene.instantiate() as PlayerController
	init_road()
	_player.position = Vector3(0, 0, (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_player.cur_row_ind))
	add_child(_player)
	_player.add_to_group("Player")
	#print(_player.get_groups())
	
	increase_difficulty_interval.timeout.connect(update_difficulty)
	stop_game()
	_game_init_complete = true
	
#	_tween = create_tween()
	#_cur_player_position_type = Constants.PositionType.MIDDLE
	
	
#	for drone_slot in drone_slots.get_children():
#		_free_drone_slots_array.append(drone_slot)

func start_game():
	GameSignals.boxes_hit_counter = 0
	GameSignals.bottles_collected_counter = 0
	GameSignals.game_total_time = 0
	GameSignals.game_total_distance = 0
	boxes_to_spawn_modificator = 0
	bottles_to_spawn_modificator = 0
	
	_player.start_it(true)
	
	increase_difficulty_interval.start()
	_game_is_in_process = true
	

var _game_init_complete: bool

func stop_game():
	boxes_to_spawn_modificator = -10
	bottles_to_spawn_modificator = -10
	increase_difficulty_interval.stop()
	
	_player.start_it(false)
	
	_game_is_in_process = false
	
	
	for road in queue:
		road.destroy_everything(_game_init_complete)


func update_difficulty():
	boxes_to_spawn_modificator += increase_boxes_per_interval
	bottles_to_spawn_modificator += increase_bottles_per_interval



var move_for_value : float

func _process(delta):
	#if (Input.is_action_just_pressed("jump")):
		#stop_game()

	if (_cur_road_remaining_length > 0.0):
		move_for_value = road_speed * delta
		for road : RoadPiece in queue:
			road.position += Vector3(-move_for_value, 0.0, 0.0)
		_cur_road_remaining_length -= move_for_value
		_front_position -= move_for_value
	else:
		do_update_structure()
		_cur_road_remaining_length = (queue[_cur_road_ind] as RoadPiece).road_length + _cur_road_remaining_length
	
	if _game_is_in_process:
		GameSignals.game_total_time += delta
		GameSignals.game_total_distance += road_speed * delta
	

	
	if (queue[_cur_road_ind-1] as RoadPiece).current_obstacle != null && _player.cur_player_position_type == (queue[_cur_road_ind-1] as RoadPiece).current_obstacle.position_type:
		(queue[_cur_road_ind-1] as RoadPiece).destroy_current_obstacle()
		_player.blood_stains_component.split_alot()
		_player.health_component.take_hit_damage()
		_player.movement_component.shake_x()
		GameSignals.boxes_hit_counter += 1
	if cur_road.current_bottle != null && _player.cur_player_position_type == cur_road.current_bottle.position_type:
		cur_road.destroy_current_bottle()
		_player.health_component.take_bottle_heal()
		GameSignals.boxes_hit_counter += 1
		
		


func init_road():
	_front_position = 0.0
	while (queue.size() < max_queue_size):
		var road_instance = road_scene.instantiate() as RoadPiece
		_roads_structure.add_child(road_instance)
		road_instance.init(boxes_to_spawn_modificator, bottles_to_spawn_modificator)
		
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
	_player.cur_row_ind = (queue[_cur_road_ind] as RoadPiece).road_width / 2
	
	GameSignals.current_road_changed.emit(cur_road)
	

func do_update_structure():
	finish_queue_front()
	var road_instance = road_scene.instantiate() as RoadPiece
	_roads_structure.add_child(road_instance)
	road_instance.init(boxes_to_spawn_modificator, bottles_to_spawn_modificator)
	#road_instance.fill_cells_matrix()
	road_instance.position = Vector3(_front_position, 0.0, 0.0)
	_front_position += road_instance.road_length
	#print_debug((road_instance.cells_matrix[Vector2(1,1)] as Cell).position)
	#(road_instance.obstacle_placer as ObstaclePlacer).place_obstacles(road_instance.cells_matrix, road_instance.road_width, road_instance.road_length_in_cells)
	add_to_queue(road_instance)
	GameSignals.current_road_changed.emit(cur_road)




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
