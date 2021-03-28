extends KinematicBody2D

var velocity = Vector2(0,0)
var collison_ojc = KinematicBody2D

func _physics_process(delta):
	collison_ojc = move_and_collide(velocity * delta)
	if collison_ojc:
		velocity = velocity.bounce(collison_ojc.normal)

func _hit_leftright():
	$AnimationPlayer.play("hit_leftright")
	
func _hit_topbot():
	$AnimationPlayer.play("hit_topbot")

func _on_leftright_body_entered(_body):
	_hit_leftright()

func _on_topbot_body_entered(_body):
	_hit_topbot()

func _on_animation_finished(_anim_name):
	$".".scale = Vector2(2.5,2.5)

func _on_Game_started(angle):
	velocity = Vector2(sin(angle), cos(angle)) *700
	
