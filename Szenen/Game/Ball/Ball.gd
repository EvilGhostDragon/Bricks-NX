extends KinematicBody2D

const SPEED = 700

var Game = load("res://Szenen/Game/Game.tscn")
var velocity = Vector2(0,0)
var collison_ojc = KinematicBody2D
var run = false

func _ready():
	var game = Game.instance()
	game.connect("started",self,"_on_Game_started")

func _physics_process(delta):
	if get_node("/root/Game").children_run:
		collison_ojc = move_and_collide(velocity * delta)
		if collison_ojc:
			velocity = velocity.bounce(collison_ojc.normal)

func init(pos):
	position = pos
	$".".modulate = Color("ffffff")

func shoot(angle):
	velocity = Vector2(sin(angle), cos(angle)) * SPEED

func _hit_leftright():
	$AnimationPlayer.play("hit_leftright")
	
func _hit_topbot():
	$AnimationPlayer.play("hit_topbot")

func _on_leftright_body_entered(_body):
	_hit_leftright()

func _on_topbot_body_entered(_body):
	_hit_topbot()

func _on_animation_finished(_anim_name):
	$".".scale = Vector2(1,1)	
