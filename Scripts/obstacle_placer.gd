class_name ObstaclePlacer
extends Node3D

var object_scenes: Array[Variant] = [
	preload("res://Scenes/ObstacleObjects/obstacle_object1.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object2.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object3.tscn"),
]

var bottle_scenes: Array[Variant] = [
	preload("res://Scenes/Bottles/blood_bottle1.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object2.tscn"),
	#preload("res://Scenes/ObstacleObjects/obstacle_object3.tscn"),
]


#@export var min_count : int = 2
@export var max_count_obstacles : int = 10
@export var max_count_bottles : int = 5


var max_failed_iters_threshold : int = 100


func place_obstacles(cells_matrix : Dictionary, road_width : int, road_length : int) -> Array[ObstacleObject]:
	var random_width_ind : int
	var random_length_ind : int
	var cur_failed_iters : int = 0
	var cur_placed_count : int          = 0
	var obstacles_array: Array[ObstacleObject] = []
	#print (road_width)
#	print("max count: " + str(max_count_obstacles))
	while (cur_placed_count < max_count_obstacles && cur_failed_iters < max_failed_iters_threshold):
		random_width_ind = randi() % road_width
		random_length_ind = randi() % road_length
		#print(Vector2(random_width_ind, random_length_ind))
		var cur_cell: Cell = cells_matrix[Vector2(random_width_ind, random_length_ind)] as Cell
		#print("is good? - " + str(cur_cell.is_good_for_placing))
		if (cur_cell.is_good_for_placing):
			var scene_instance: ObstacleObject = object_scenes[randi() % object_scenes.size()].instantiate() as ObstacleObject
			scene_instance.position = cur_cell.position
			scene_instance.scale = cur_cell.scale
			cur_cell.obstacle_object = scene_instance
			add_child(scene_instance)
			cur_cell.is_good_for_placing = false
			if (random_length_ind - 1 >= 0):
				(cells_matrix[Vector2(random_width_ind, random_length_ind - 1)] as Cell).is_good_for_placing = false
			if (random_length_ind + 1 < road_length):
				(cells_matrix[Vector2(random_width_ind, random_length_ind + 1)] as Cell).is_good_for_placing = false
			cur_placed_count += 1
			obstacles_array.append(scene_instance)
		else:
			cur_failed_iters += 1
#	print("initial obstacles array: " + str(obstacles_array.size()))
#	print("initial obstacles array: " + str(obstacles_array))
	return obstacles_array
	
func place_bottles(cells_matrix : Dictionary, road_width : int, road_length : int) -> Array[BloodBottle]:
	var random_width_ind : int
	var random_length_ind : int
	var cur_failed_iters : int = 0
	var cur_placed_count : int               = 0
	var bottles_array: Array[BloodBottle] = []
	#print (road_width)
#	print("max count: " + str(max_count_obstacles))
	while (cur_placed_count < max_count_bottles && cur_failed_iters < max_failed_iters_threshold):
		random_width_ind = randi() % road_width
		random_length_ind = randi() % road_length
		#print(Vector2(random_width_ind, random_length_ind))
		var cur_cell: Cell = cells_matrix[Vector2(random_width_ind, random_length_ind)] as Cell
		#print("is good? - " + str(cur_cell.is_good_for_placing))
		if (cur_cell.blood_bottle == null):
			var scene_instance: BloodBottle = bottle_scenes[randi() % bottle_scenes.size()].instantiate() as BloodBottle
			scene_instance.scale = cur_cell.scale
			scene_instance.position = cur_cell.position if cur_cell.obstacle_object == null else cur_cell.position + Vector3(0,1.25,0)
			scene_instance.position_type = Constants.PositionType.MIDDLE if cur_cell.obstacle_object == null else Constants.PositionType.HIGH 
			cur_cell.blood_bottle = scene_instance
			add_child(scene_instance)

			cur_placed_count += 1
			bottles_array.append(scene_instance)
		else:
			cur_failed_iters += 1
	#	print("initial obstacles array: " + str(obstacles_array.size()))
	#	print("initial obstacles array: " + str(obstacles_array))
	return bottles_array
