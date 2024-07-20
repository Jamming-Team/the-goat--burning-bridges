class_name DroneSlot
extends Node3D

var slot_is_free : bool = true
var current_drone : Drone = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_drone(drone_scene : PackedScene):
	var drone = drone_scene.instantiate() as Drone
	current_drone = drone
	add_child(current_drone)
	slot_is_free = false

func kill_drone():
	current_drone.queue_free()

