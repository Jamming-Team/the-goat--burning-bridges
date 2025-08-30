class_name BloodBottle
extends Node3D

signal player_affected_bottle(ObstacleObject)

@export_range(0.1, 1) var hitbox_multiplier : float = 0.8
@export var position_type : Constants.PositionType
var _hitbox_component : HitboxComponent


func _ready():
	_hitbox_component = $HitboxComponent as HitboxComponent
	_hitbox_component.scale *= hitbox_multiplier
	_hitbox_component.on_hitbox_area_entered.connect(_on_entered_obstacle)
	_hitbox_component.on_hitbox_area_exited.connect(_on_exited_obstacle)
	


func _on_entered_obstacle(area : Area3D) -> void:
	#print("test2")
	
	if area.get_parent().is_in_group("Player"):
		player_affected_bottle.emit(self)
		return



func _on_exited_obstacle(area : Area3D) -> void:
	if area.is_in_group("Player"):
		player_affected_bottle.emit(null)
		return
