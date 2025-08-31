class_name OneShotSound
extends AudioStreamPlayer3D


func shot(set_stream: AudioStream):
	stream = set_stream 
	pitch_scale += randf() * 0.1
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !playing:
		queue_free()
