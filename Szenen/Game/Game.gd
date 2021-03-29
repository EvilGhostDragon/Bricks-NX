extends Node2D

signal started

var project_resolution=Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))
var Brick = preload("res://Szenen/Game/Brick/Brick.tscn")
var Powerup = preload("res://Szenen/Game/Powerup/Powerup.tscn")
var Ball = preload("res://Szenen/Game/Ball/Ball.tscn")
var health = 3
var score = 0
var game_started = false
var children_run = false
var level = 1
var brick_lines = 3

var first_ball

func test():
	score += 1
	update_hud()

func _ready():
	$Fade.fade_out()
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
		get_tree().change_scene("res://Szenen/Title Screen/Title Screen.tscn")
		save()
	

	if not game_started:
		if Input.is_action_pressed("game_left") and $Line2D.rotation >= deg2rad(-80):
			$Line2D.rotate(deg2rad(-2))
		if Input.is_action_pressed("game_right")and $Line2D.rotation <= deg2rad(80):
			$Line2D.rotate(deg2rad(2))

		if Input.is_action_just_pressed("game_shoot") or Input.is_action_just_released("game_touch"):
			start_game()
	if Input.is_action_just_pressed("game_pause"):
		get_tree().paused = true
		$Pause.show()
	if $Bricks.get_child_count() <= 0 and game_started:
		level_cleared()

	if Input.is_action_just_pressed("test_skiplevel"):
		for _brick in $Bricks.get_children():
			$Bricks.remove_child(_brick)
		
func _input(_event):
	if Input.is_action_just_released("game_touch"):
		if get_global_mouse_position().x < project_resolution.x/2:
			Input.action_release("game_left")
		else:
			Input.action_release("game_right")
	if Input.is_action_just_pressed("game_touch"):
		if get_global_mouse_position().x < project_resolution.x/2:
			Input.action_press("game_left")
		else:
			Input.action_press("game_right")

func level_cleared():
	game_started = false
	level += 1
	$LevelClearedTimer.start(1)
	$Fade.fade_inout()
	for powerup in $Powerups.get_children():
		powerup.set_process(false)

func stop_game():
	update_hud()
	game_started = false
	children_run = game_started
	$Player.set_physics_process(children_run)
	for powerup in $Powerups.get_children():
		powerup.set_process(children_run)

func start_game():
	emit_signal("started",$Line2D.rotation)
	first_ball.shoot($Line2D.rotation)
	game_started = true
	children_run = game_started
	$Line2D.hide()
	$Player.set_physics_process(children_run)
	for powerup in $Powerups.get_children():
		powerup.set_process(children_run)
	$Player.velocity = Vector2(0,0)

func start_setup():
	stop_game()
	$Line2D.rotation_degrees = 0
	$Line2D.show()
	$Player.position = Vector2(490,670)
	first_ball = Ball.instance()
	first_ball.init(Vector2(640,660))
	$Balls.add_child(first_ball)
	
	
func build_stage():
	start_setup()
	if level%10 == 0 and level <= 20:
		brick_lines += 1
	for i in range(5):
		for ii in range(brick_lines):
			randomize()
			if not randi() % (level + 1) == 1:
				var brick = Brick.instance()
				var pos = Vector2(160+i*240,80+ii*60)
				brick.init(pos,randi() % level +1)
				brick.connect("destroyed",self,"_on_Brick_destroyed")
				$Bricks.add_child(brick)

func update_hud():
	$HUD/Panel/Label.text = str(health)
	$HUD/Panel2/Label.text = str(score)
	
func save_score():
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json({"highscore":score}))
	save_file.close()

func save():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		save_score()
	else:
		save_file.open("user://savegame.save", File.READ)
		var save_data = parse_json(save_file.get_line())
		var score_old = save_data["highscore"]
		save_file.close()
		if score_old < score:
			save_score()

func add_ball():
	var ball = Ball.instance()
	ball.init(Vector2($Player.position.x + 150, $Player.position.y - 15))
	$Balls.add_child(ball)
	ball.shoot(deg2rad((randi()%140)-70))

func _on_DeadArea_body_entered(body):
	body.queue_free()
	if $Balls.get_child_count() > 1:
		return
	if game_started:
		health -= 1
	stop_game()
	$DeathTimer.start(0.1)

func _on_Pause_pressed():
	$Pause.hide()
	get_tree().paused = false
	
func _on_Brick_destroyed(value):
	if $Powerups.get_child_count() > 0:
		for powerup in $Powerups.get_children():
			if not powerup.is_connected("powerupCollected",self,"_on_Powerup_collected"):
				powerup.connect("powerupCollected",self,"_on_Powerup_collected")
	score += value
	update_hud()

func _on_Powerup_collected(type):
	score += 10
	randomize()
	match type:
		0: 
			health += 1
		1:
			call_deferred("add_ball")
		_: pass
	update_hud()

func _on_LevelClearedTimer_timeout():
	children_run = false
	for ball in $Balls.get_children():
		ball.queue_free()
	build_stage()
	
func _on_DeathTimer_timeout():
	children_run = false
	start_setup()

