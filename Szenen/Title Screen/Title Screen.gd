extends Control

var scene_path_to_load
var highscore = 0

func _ready():
	$Fade.fade_out()
	$"Menu/Buttons/New Game".grab_focus()
	for button in $Menu/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	$"Menu/Version Label".text = "v1.0.0"
	$Fade.connect("fadein_finished",self,"_on_FadeIn_finished")
	
	var save_file = File.new()
	if save_file.file_exists("user://savegame.save"):
		save_file.open("user://savegame.save", File.READ)
		highscore = parse_json(save_file.get_line())["highscore"]
		
	
	$Panel/VBoxContainer/Highscore.text = str(highscore)

func _on_Button_pressed(scene_to_load):
	if scene_path_to_load:
		scene_path_to_load = scene_to_load
		$Fade.fade_in()

func _on_FadeIn_finished():
	get_tree().change_scene(scene_path_to_load)


func _on_Exit_pressed():
	get_tree().quit()
