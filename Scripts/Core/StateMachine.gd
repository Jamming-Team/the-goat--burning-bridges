class_name StateMachine
extends Node


@export var states: Array[State]

var cur_state: State
var prev_state: State

func _ready() -> void:
	init()

func init():
	for state in states:
		state.init(self)
	
	change_state(states[0])

func change_state(target_state: State):
	if cur_state:
		prev_state = cur_state
		prev_state.exit()
	
	cur_state = target_state
	cur_state.enter()
