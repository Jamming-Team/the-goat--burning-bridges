class_name Health
extends Node

@export var max_value : float = 100
@export var depletion_speed : float = 10
@export var hit_damage : float = 10
@export var bottle_heal : float = 20

@onready var current : float = max_value:
	set(value):
		current = clamp(value, 0, max_value)
		SharedVariables.health_changed.emit(current)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current -= depletion_speed * delta;
	#print_debug(current)

func take_hit_damage():
	current -= hit_damage

func take_bottle_heal():
	current += bottle_heal
	print_debug("heal")
