extends Node

signal game_over
signal health_changed(value: float)
signal current_road_changed(road: RoadPiece)
signal set_view_type(type : Constants.ViewTypes)
signal button_pressed(type: Constants.ButtonTypes)

#var cur_health : float

var boxes_hit_counter : int
var bottles_collected_counter : int
var game_total_time : int
var game_total_distance : int
