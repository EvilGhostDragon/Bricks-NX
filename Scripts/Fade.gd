extends ColorRect

signal fadein_finished
signal fadeout_finished


func _ready():
	$".".set_size(Vector2(1280,720))
	$".".hide()

func fade_custom(speed):
	if speed <= 0:
		$".".color.a = 255
	else:
		$".".color.a = 0
	$AnimationPlayer.play("fade_in",-1,speed)
	$".".show()

func fade_in():
	$".".color.a = 0
	$AnimationPlayer.play("fade_in")
	$".".show()

func fade_out():
	$".".color.a = 255
	$AnimationPlayer.play("fade_out")
	$".".show()

func fade_inout():
	if $AnimationPlayer.is_playing():
		fade_inout()
	$AnimationPlayer.play("fade_inout")
	$".".show()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		emit_signal("fadeout_finished")
	if anim_name == "fade_in":
		emit_signal("fadein_finished")
		
	$".".hide()
