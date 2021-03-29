extends Area2D

signal powerupCollected

const SPEED = 5

var Health = preload("res://Assets/Icons/heart.svg")
var type_id
var velocity

func _process(delta):
	position.y += SPEED
	
	

func init(pos):
	position = pos
	randomize()
	#var type_id = randi() % 3
	type_id = 0
	match type_id:
		0: $Sprite.texture = Health
		_: queue_free()



func _on_Powerup_body_entered(_body):
	queue_free()
	emit_signal("powerupCollected",type_id)


func _on_Powerup_area_entered(_area):
	queue_free()
