extends Control

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeIn.fade_out()
	$"Menu/Buttons/New Game".grab_focus()
	for button in $Menu/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	$"Menu/Version Label".text = "v1.0.0"
	$FadeIn.connect("fadein_finished",self,"_on_FadeIn_finished")

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
	
func _on_FadeIn_finished():
	
	get_tree().change_scene(scene_path_to_load)
	
