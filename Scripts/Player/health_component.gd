class_name HealthComponent
extends Node

@export var max_value : float = 100
@export var depletion_speed : float = 10
@export var hit_damage : float = 10
@export var bottle_heal : float = 20

@onready var current : float = max_value:
	set(value):
		current = clamp(value, 0, max_value)
		GameSignals.health_changed.emit(current)
		if current == 0:
			GameSignals.game_over.emit()

var _is_active: bool

func start_it(flag: bool):
	if flag:
		current = max_value
		_is_active = true
	else:
		_is_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_active:
		current -= depletion_speed * delta;
	#print_debug(current)

func take_hit_damage():
	current -= hit_damage

func take_bottle_heal():
	current += bottle_heal
