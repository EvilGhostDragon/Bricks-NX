extends KinematicBody2D

const SPEED = 400
const FIX_POS = -670
var velocity = Vector2(1,0)

var game_started = false

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	global_position.y = -FIX_POS
	#velocity.y = 0.0
	velocity = move_and_slide(velocity,Vector2.UP)
	#velocity = lerp(velocity.x,0,0.2)
	if Input.is_action_pressed("game_left") and game_started:
		velocity.x = -SPEED
	if Input.is_action_pressed("game_right") and game_started:
		velocity.x = SPEED
	
	velocity.x = lerp(velocity.x,0,0.2)
	


func _on_Game_started(_angel):
	game_started = true


func _on_Game_stopped():
	game_started = false
