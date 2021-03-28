extends Node2D

signal started
signal stopped


var project_resolution=Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))
var health = 30
var score = 0
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():

	var border_top = RectangleShape2D.new()
	var border_leftright = RectangleShape2D.new()
	var shape_width = Vector2(project_resolution.x/2,10)
	var shape_height = Vector2(10,project_resolution.y/2)
	var polygon_top = Polygon2D.new()
	var polygon_leftright = Polygon2D.new()
	
	border_top.extents = shape_width
	border_leftright.extents = shape_height
	polygon_leftright.draw_polyline([Vector2(0,0),Vector2(-10,0),Vector2(-10,-project_resolution.y),Vector2(0,-project_resolution.y)],Color("ffffff"))
	
	#$Borders/Left.add_child_below_node(get_node("Borders/Left"),polygon_leftright)
	
	$Borders/Top/CollisionShape2D.shape = border_top
	$Borders/Top/CollisionShape2D.position = Vector2(shape_width.x,10)
	$Borders/Right/CollisionShape2D.shape = border_leftright
	$Borders/Right/CollisionShape2D.position = Vector2(10,shape_height.y)
	$Borders/Left/CollisionShape2D.shape = border_leftright
	$Borders/Left/CollisionShape2D.position = Vector2(project_resolution.x-10,shape_height.y)
	
	
	
	start_setup()
	
	


func _physics_process(_delta):
	if health <= 0:
		if not get_tree().change_scene("res://Szenen/Title Screen/Title Screen.tscn"):
			pass
	
	$HUD/Panel/Label.text = str(health)
	$HUD/Panel2/Label.text = str(score)
	if not game_started:
		if Input.is_action_pressed("game_left") and $Line2D.rotation >= deg2rad(-80):
			$Line2D.rotate(deg2rad(-2))
		if Input.is_action_pressed("game_right")and $Line2D.rotation <= deg2rad(80):
			$Line2D.rotate(deg2rad(2))
			
		if Input.is_action_just_pressed("game_shoot"):
			emit_signal("started",$Line2D.rotation)
			game_started = true
			$Line2D.hide()

func _on_DeadArea_body_entered(_body):
	health -= 1
	emit_signal("stopped")
	$DeathTimer.start(1)
	game_started = false


func start_setup():
	$Line2D.rotation_degrees = 0
	$Line2D.show()
	$Player.position = Vector2(490,670)
	$Ball.position = Vector2(640,670)
	$Ball.velocity = Vector2(0,0)


func _on_DeathTimer_timeout():
	start_setup()


func _on_Ball_test_signal(points):
	score += points
