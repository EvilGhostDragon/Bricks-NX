extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Title Screen/Menu/Version Label").text = "v1.0.0 / HeisIT"

