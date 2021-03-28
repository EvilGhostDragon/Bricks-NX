extends Control


func _ready():
	$Timer.start(3)
	$Fade.connect("fadein_finished",self,"_on_FadeIn_finished")
func _on_Timer_timeout():
	$Fade.fade_custom(0.3)

func _on_FadeIn_finished():
	get_tree().change_scene("res://Main.tscn")
	
