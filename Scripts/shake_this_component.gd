extends Node3D

@export var max_angle_change : float = 30
@export var max_position_change : float = 0.1
#@export var 
var _initial_position : Vector3 
var _target_position : Vector3
var _target_rotation : Vector3
var _movement_vector : Vector3
var _start_position : Vector3
var _parent : Node3D
var _cur_track : int

# Called when the node enters the scene tree for the first time.
func _ready():
	_parent = get_parent() as Node3D
	_initial_position = _parent.position
	_target_position = _parent.position
	_cur_track = 1

var t : float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((_parent.position - _target_position).length() <= 0.001):
		_start_position = _parent.position
		
		_cur_track = -_cur_track
		var rand_x = (randf()) * _cur_track
		var rand_y = (randf() * 2 - 1)
		var rand_z = (randf() * 2 - 1) /3
		
		_movement_vector = Vector3(rand_x, rand_y, rand_z).normalized()
		_target_position = _initial_position + max_position_change * _movement_vector
		print("rand_x: " + str(rand_x))
		var mark_change = lerp(-max_angle_change, max_angle_change, inverse_lerp(-1, 1, -rand_x))
		_target_rotation = Vector3(0, 0, mark_change)
		t = 0.0
	var x = inverse_lerp((_start_position - _target_position).length(), 0, (_parent.position - _target_position).length())
	print ("1: " + str((_start_position - _target_position).length()) + ", 2: " + str((_parent.position - _target_position).length()))
	print ("where we are: " + str(x))
	x = lerp(-7, 7, x)
	t += delta * (-x*x * 0.02 + 1) *1
	print("speed = " + str((-x*x * 0.1 + 1)))
	_parent.position = lerp(_start_position, _target_position, t)
	_parent.rotation_degrees = _parent.rotation_degrees.slerp(_target_rotation, delta * 0.2)
	
