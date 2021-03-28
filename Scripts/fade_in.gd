extends ColorRect

signal fadein_finished
signal fadeout_finished

func _ready():
	$".".set_size(Vector2(1280,720))

func fade_in():
	$AnimationPlayer.play("fade_in")
	$".".show()

func fade_out():
	$AnimationPlayer.play("fade_out")
	$".".show()

func fade_inout():
	if $AnimationPlayer.is_playing():
		fade_inout()
		print("aa")
	$AnimationPlayer.play("fade_inout")
	$".".show()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		emit_signal("fadeout_finished")
	if anim_name == "fade_in":
		emit_signal("fadein_finished")
		
	$".".hide()
