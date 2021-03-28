extends Node2D

signal started


var project_resolution=Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))
var Brick = preload("res://Szenen/Game/Brick/Brick.tscn")
var health = 3
var score = 0
var game_started = false
var level = 9
var brick_lines = 3

func _ready():
	$FadeIn.fade_out()
	var border_top = RectangleShape2D.new()
	var border_leftright = RectangleShape2D.new()
	var shape_width = Vector2(project_resolution.x/2,10)
	var shape_height = Vector2(10,project_resolution.y/2)
	
	border_top.extents = shape_width
	border_leftright.extents = shape_height
	
	$Borders/Top/CollisionShape2D.shape = border_top
	$Borders/Top/CollisionShape2D.position = Vector2(shape_width.x,10)
	$Borders/Right/CollisionShape2D.shape = border_leftright
	$Borders/Right/CollisionShape2D.position = Vector2(10,shape_height.y)
	$Borders/Left/CollisionShape2D.shape = border_leftright
	$Borders/Left/CollisionShape2D.position = Vector2(project_resolution.x-10,shape_height.y)
	
	build_stage()

func _physics_process(_delta):
	if health <= 0:
		if not get_tree().change_scene("res://Szenen/Title Screen/Title Screen.tscn"):
			pass
	
	if not game_started:
		if Input.is_action_pressed("game_left") and $Line2D.rotation >= deg2rad(-80):
			$Line2D.rotate(deg2rad(-2))
		if Input.is_action_pressed("game_right")and $Line2D.rotation <= deg2rad(80):
			$Line2D.rotate(deg2rad(2))
			
		if Input.is_action_just_pressed("game_shoot"):
			start_game()
	if Input.is_action_just_pressed("game_pause"):
		get_tree().paused = true
		$Pause.show()
	if $Bricks.get_child_count() <= 0 and game_started:
		level_cleared()
		
#	if Input.is_action_just_pressed("test_skiplevel"):
#		level += 1
#		for _brick in $Bricks.get_children():
#			$Bricks.remove_child(_brick)
		

func level_cleared():
	game_started = false
	#$GameAnimation.play("level_cleared")
	$LevelClearedTimer.start(1)	
	$FadeIn.fade_inout()

func stop_game():
	update_hud()
	game_started = false
	$Player.set_physics_process(game_started)
	
func start_game():
	emit_signal("started",$Line2D.rotation)
	game_started = true
	$Line2D.hide()
	$Player.set_physics_process(game_started)
	$Player.velocity = Vector2(0,0)

func start_setup():
	stop_game()
	$Line2D.rotation_degrees = 0
	$Line2D.show()
	$Player.position = Vector2(490,670)
	$Ball.position = Vector2(640,670)
	$Ball.velocity = Vector2(0,0)
	$Ball.modulate = Color("ffffff")
	
func build_stage():
	start_setup()
	if level%10 == 0 and level <= 20:
		brick_lines += 1
	for i in range(5):
		for ii in range(brick_lines):
			randomize()
			if not randi() % level == 1:
				var brick = Brick.instance()
				var pos = Vector2(160+i*240,80+ii*60)
				brick.init(pos,randi() % level +1)
				brick.connect("destroyed",self,"_on_Brick_destroyed")
				$Bricks.add_child(brick)
	
	
	
func update_hud():
	$HUD/Panel/Label.text = str(health)
	$HUD/Panel2/Label.text = str(score)

func _on_DeadArea_body_entered(_body):
	if game_started:
		health -= 1
	stop_game()
	$DeathTimer.start(1)

func _on_DeathTimer_timeout():
	start_setup()

func _on_Pause_pressed():
	$Pause.hide()
	get_tree().paused = false
	
func _on_Brick_destroyed(value):
	score += value
	update_hud()


func _on_LevelClearedTimer_timeout():
	build_stage()
