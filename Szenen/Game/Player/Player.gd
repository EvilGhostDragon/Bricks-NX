extends KinematicBody2D

const SPEED = 400
const FIX_POS = -670
var velocity = Vector2(1,0)


func _physics_process(_delta):
	global_position.y = -FIX_POS
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.2)
	if Input.is_action_pressed("game_left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("game_right"):
		velocity.x = SPEED
	

