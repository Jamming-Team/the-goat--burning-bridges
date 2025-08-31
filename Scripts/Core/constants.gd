extends Node

enum ButtonTypes
{
	Play,
	HowToPlay,
	Understood,
	Quit,
	Fullscreen
}

enum ViewTypes
{
	Main,
	HowToPlay,
	Action,
	PostGame
}

enum PositionType
{
	HIGH,
	MIDDLE,
	LOW
}

const player_layer : String = "player"
const projectile_layer : String = "projectile"

var _physical_layers = []


func _ready():
	for i in range(1, 21):
		_physical_layers.append(ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i)))


func get_layer(layer_name : String) -> int:
	return _physical_layers.find(layer_name) + 1
