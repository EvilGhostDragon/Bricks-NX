extends StaticBody2D

signal destroyed

var Powerup = preload("res://Szenen/Game/Powerup/Powerup.tscn")
var color
var destroyed_points
var health = 1

func _process(_delta):
	if health <= 0:
		randomize()
		if randi()%3 == 1:
			print("1")
			generate_powerup()
		queue_free()
		emit_signal("destroyed",destroyed_points)

func set_color():
	match health:
		1: color = "8E0000"
		2: color = "D99A02"
		3: color = "FDFF5A"
		4: color = "7EFF87"
		5: color = "136319"
		6: color = "1CEEE5"
		7: color = "004AAC"
		8: color = "5D0089"
		9: color = "2C0061"
		_: color = "ffffff"
	
	$Polygon2D.color = Color(color)

func init(pos,brick_health):
	position = pos
	health = brick_health
	if brick_health > 9:
		health = 9
	destroyed_points = health * 100
	set_color()

func generate_powerup():
	var powerup = Powerup.instance()
	powerup.init(position)
	get_node("/root/Game/Powerups").add_child(powerup)

func _on_HitArea_body_entered(_body):
	health -= 1
	set_color()
