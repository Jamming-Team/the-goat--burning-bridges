class_name Drone
extends Node3D

var is_initialized : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#position = Vector3(0, 0, 0)
	#pass
	await _appear()
	$ShakeThisComponent.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _appear():
	position = Vector3(0, 10, -10)
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0, -0.3, 0.3), 1)
	tween.tween_property(self, "position", Vector3(0, 0, 0), 0.1)
	await get_tree().create_timer(1.5).timeout
	is_initialized = true
