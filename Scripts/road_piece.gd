class_name RoadPiece
extends Path3D

@export var road_length : float
@export var road_width : int
@export var road_length_in_cells : int
@export var first_row_coords : float
@export var cell_size : float

var cells_matrix : Dictionary
var current_obstacle : ObstacleObject = null
var _obstacles_array : Array

@onready var cells_container = $CellsContainer
@onready var obstacle_placer : ObstaclePlacer = $ObstaclePlacer


func _ready():
	fill_cells_matrix()
	_obstacles_array = obstacle_placer.place_obstacles(cells_matrix, road_width, road_length_in_cells)
	print("obstacles_array: " + str(_obstacles_array.size()))
	for obstacle in _obstacles_array:
		(obstacle as ObstacleObject).player_affected_obstacle.connect(set_current_obstacle)

func fill_cells_matrix():
	for cell in cells_container.get_children():
		cells_matrix[(cell as Cell).coords] = cell


func get_current_row_coords(row_ind : int) -> float:
	return first_row_coords + cell_size * row_ind


func set_current_obstacle(new_obstacle : ObstacleObject):
	current_obstacle = new_obstacle
	print("this road: " + str(self))
	print("current obstacle: " + str(current_obstacle))

func destroy_current_obstacle():
	print(_obstacles_array.size())
	current_obstacle.player_affected_obstacle.disconnect(set_current_obstacle)
	_obstacles_array.erase(current_obstacle)
	print(_obstacles_array.size())
	current_obstacle.queue_free()
	current_obstacle = null
