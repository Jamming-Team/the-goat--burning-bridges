class_name State
extends Node


@export var _view_type : Constants.ViewTypes

var _state_machine : StateMachine


func init(state_machine : StateMachine):
	_state_machine = state_machine

func enter():
	GameSignals.set_view_type.emit(_view_type)
	_on_enter()

func exit():
	_on_exit()

func _on_enter():
	GameSignals.button_pressed.connect(_on_button_pressed)

func _on_exit():
	GameSignals.button_pressed.disconnect(_on_button_pressed)

func _on_button_pressed(type : Constants.ButtonTypes):
	pass
