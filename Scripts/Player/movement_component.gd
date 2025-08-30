class_name MovementComponent
extends Node

@export var _max_jump_height : float = 2
#@export var _max_jumo_velocity : float = 2
@export var _gravity : float = 2
@export var _max_jump_time : float = 2
@export var _min_jump_time : float = 0.2
@export var _threshold_for_second_move : float = 0.1

@onready var _move_cooldown_timer : Timer = $MoveCooldown
@onready var _move_pressed_time : float = 0
#@onready var _pre_jump_timer : Timer = $PreJumpTimer

var _player : PlayerController
var _input_component : InputComponent
var _jump_is_pressed : bool
var _move_is_pressed : bool
var _first_move_fired : bool
#var _y_velocity : float
var _y_velocity_tween : Tween
var cur_road : RoadPiece



func init(player : PlayerController, input_component : InputComponent):
	_player = player
	_input_component = input_component 
	
	_input_component.jump_pressed.connect(_process_jump_press)
	_player.cur_player_position_type = Constants.PositionType.MIDDLE
	GameSignals.current_road_changed.connect(func(x): cur_road = x)
	
	_input_component.movement_pressed.connect(_process_move_press)

func _process_move_press(pressed: bool):
	_move_is_pressed = pressed
	if (not pressed):
		_move_pressed_time = 0
		_first_move_fired = false

#func _ready() -> void:
	#_input_component.jump_pressed.connect(_process_jump)
	#_y_velocity_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	#_y_velocity_tween.tween_property(_player, "position:y", _max_jump_height, _max_jump_time).from(_player._initial_player_y)
	#_y_velocity_tween.stop()

func _process_jump_press(pressed : bool):
	_jump_is_pressed = pressed
	
	#if (pressed == false):
#
		#_y_velocity_tween.play()
		#_y_velocity_tween = get_tree().create_tween()
		#_y_velocity_tween.tween_property(_player, "position:y", _max_jump_height, _max_jump_time).from(_player._initial_player_y).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		#_y_velocity_tween.stop()
	
	
	
	#if (pressed == false and _y_velocity_tween.is_running()):
		#_y_velocity_tween.stop()
	

func _process(delta: float) -> void:
	if (_move_is_pressed):
		_move_pressed_time += delta
	
	_process_y(delta)
	_process_z(delta)
	
	
func _process_y(delta: float) ->  void:
	if (_player.is_grounded and _jump_is_pressed):
		_y_velocity_tween = get_tree().create_tween()
		_y_velocity_tween.set_ease(Tween.EASE_OUT)
		_y_velocity_tween.set_trans(Tween.TRANS_QUINT)
		_y_velocity_tween.tween_property(_player, "position:y", _max_jump_height, _max_jump_time).from(_player.initial_player_y)
		_player.cur_player_position_type = Constants.PositionType.HIGH
		return
	
	if _y_velocity_tween != null:
		if not _jump_is_pressed and _y_velocity_tween.is_running() and _y_velocity_tween.get_total_elapsed_time() > _min_jump_time:
			_y_velocity_tween.stop()
		
		if not _y_velocity_tween.is_running():
			_player.position.y = max(_player.initial_player_y, _player.position.y - _gravity * delta)
	
	if _player.is_grounded:
		_player.cur_player_position_type = Constants.PositionType.MIDDLE



func _process_z(delta: float) -> void:
	var cur_side_mov_dir: int = _input_component.side_movement
	#if (cur_side_mov_dir != 0):
		
	if (cur_side_mov_dir != 0 && _move_cooldown_timer.is_stopped() and cur_road and (not _first_move_fired or _move_pressed_time >_threshold_for_second_move)):
		##print(str(cur_side_mov_dir) + str((queue[_cur_road_ind] as RoadPiece).road_width - 1) + " " + str(_cur_row_ind + cur_side_mov_dir))
		_player.cur_row_ind = clampi(_player.cur_row_ind + cur_side_mov_dir, 0, cur_road.road_width - 1)
		##var a = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		var new_row_coords = cur_road.get_current_row_coords(_player.cur_row_ind)
		##print("row ind: " + str(_cur_row_ind) + ", row coords: " + str(new_row_coords))
		##print("road ind: " + str(_cur_road_ind))
		var tween: Tween = create_tween()
		tween.tween_method(func(x): _player.position.z = x, _player.position.z, new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
		tween.tween_method(func(x): _player.position.z = x, new_row_coords + 0.2 * cur_side_mov_dir, new_row_coords, 0.05)
		##		tween.tween_property(_player, "position.x", new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
		##		tween.tween_property(_player, "position.x", new_row_coords, 0.05)
		##tween.interpolate_value(_player.position, Vector3(0, 0, new_row_coords - _player.position.z), 0, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
		##_player.position = Vector3(0, 0, new_row_coords)
		_move_cooldown_timer.start()
		_first_move_fired = true

#@export var jump_height : float = 2
#@export var jump_length : float = 4
#var _cur_x : float
#var _cur_k : float
#func process_jump(call_type : int = 0):
#	if call_type == 0 and (_player as Player).position.y == 0:
#		_cur_x = -jump_length / 2
#		_cur_player_position_type = Constants.PositionType.HIGH
#		#print("test2")
#		_cur_k = jump_height / (jump_length / 2 * jump_length / 2)
#		#print("k: " + str(_cur_k))
#		return
#	#print("test")
#
#	if (call_type == 0):
#		_pre_jump_timer.start();
#
#	(_player as Player).position.y =  -(_cur_x * _cur_x) * _cur_k + jump_height
#	_cur_x += move_for_value
#	#print(move_for_value)
#	#print(_cur_x)
#
#	if (_cur_x > jump_length / 2):
#		_cur_player_position_type = Constants.PositionType.MIDDLE
#
#
#func _physics_process(delta):
	#var cur_side_mov_dir: int = _input_component.side_movement
	#if (cur_side_mov_dir != 0 && _move_cooldown_timer.is_stopped()):
		##print(str(cur_side_mov_dir) + str((queue[_cur_road_ind] as RoadPiece).road_width - 1) + " " + str(_cur_row_ind + cur_side_mov_dir))
		#_cur_row_ind = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		##var a = clampi(_cur_row_ind + cur_side_mov_dir, 0, (queue[_cur_road_ind] as RoadPiece).road_width - 1)
		#var new_row_coords = (queue[_cur_road_ind] as RoadPiece).get_current_row_coords(_cur_row_ind)
		##print("row ind: " + str(_cur_row_ind) + ", row coords: " + str(new_row_coords))
		##print("road ind: " + str(_cur_road_ind))
		#var tween: Tween = create_tween()
		#tween.tween_method(func(x): _player.position.z = x, _player.position.z, new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
		#tween.tween_method(func(x): _player.position.z = x, new_row_coords + 0.2 * cur_side_mov_dir, new_row_coords, 0.05)
		##		tween.tween_property(_player, "position.x", new_row_coords + 0.2 * cur_side_mov_dir, 0.1)
		##		tween.tween_property(_player, "position.x", new_row_coords, 0.05)
		##tween.interpolate_value(_player.position, Vector3(0, 0, new_row_coords - _player.position.z), 0, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
		##_player.position = Vector3(0, 0, new_row_coords)
		#_move_cooldown_timer.start()
#
	#if (!_cur_player_position_type == Constants.PositionType.HIGH):
		#if (_input_component.crouch == 1):
			#_player.position.y = _initial_player_y - 0.5
			#_cur_player_position_type = Constants.PositionType.LOW
		#else:
			#_player.position.y = _initial_player_y
			#_cur_player_position_type = Constants.PositionType.MIDDLE
	#else:
		##print_debug("test3")
		#process_jump(1)
		#
		#
	
