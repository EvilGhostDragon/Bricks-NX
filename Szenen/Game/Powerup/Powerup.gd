extends Area2D

signal powerupCollected

const SPEED = 5

var Health = preload("res://Assets/Icons/heart.svg")
var Ball = preload("res://Assets/Sprites/BrickBall.piskel")
var type_id
var velocity

func _process(_delta):
	position.y += SPEED
func init(pos):
	position = pos
	randomize()
	type_id = randi() % 2
	print(type_id)
	match type_id:
		0: 
			$Sprite.texture = Health
		1: 
			$Sprite.texture = Ball
			$Sprite.scale = Vector2(1.5,1.5)
		_: queue_free()



func _on_Powerup_body_entered(_body):
	queue_free()
	emit_signal("powerupCollected",type_id)


func _on_Powerup_area_entered(_area):
	queue_free()
