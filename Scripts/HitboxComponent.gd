class_name HitboxComponent
extends Area3D

signal on_hitbox_area_entered(Area3D)
signal on_hitbox_area_exited(Area3D)

@export var is_active : bool = true


func _on_area_entered(area):
#	if self.get_parent().get_groups().size() == 0:
#		print("test")
	if is_active:
		on_hitbox_area_entered.emit(area)


func _on_area_exited(area):
	if is_active:
		on_hitbox_area_exited.emit(area)
