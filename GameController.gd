extends Node
var snake
var window_border
var prevHighScore
var bottle = load("res://Sprites/bottle.png")
var biriyani = load("res://Sprites/biryani.png")
var parotta = load("res://Sprites/parotta.png")
var jeiImg = load("res://Sprites/fei.jpg")
var pavanImg = load("res://Sprites/pavan.jpg")
var hsBeat
var farr = [biriyani , parotta]
var once = true
var infinityMode = false


func _ready():
	prevHighScore = loadHS()
	$highScore.text = "HighScore:%s"%prevHighScore[1]
	$jei.connect("pressed", self, "_button_pressed_1")
	$pavan.connect("pressed", self, "_button_pressed_2")
	window_border = OS.get_window_size()
	var classLoad = load("res://Scripts/Snake.gd")
	snake = classLoad.new()
	draw_food()
	$food.visible = true
	
func _button_pressed_1():
	if $infBox.is_pressed():
		infinityMode = true
	$"snake/body 0".texture = jeiImg
	$Timer.start()
	$jei.visible = false
	$pavan.visible = false
	$infBox.visible = false
	
	
func _button_pressed_2():
	if $infBox.is_pressed():
		infinityMode = true
	$"snake/body 0".texture = pavanImg	
	$Timer.start()
	$pavan.visible = false
	$jei.visible = false
	$infBox.visible = false

func random_food():
	randomize()
	var x= (randi() % 20) * snake.width
	var y= (randi() % 20) * snake.width
	return Vector2(x,y)
	
func draw_food():
	var new_rand_pos = random_food()
	for block in snake.body:
		if block == new_rand_pos:
			new_rand_pos = random_food()
			continue
		if(block == snake.body[snake.body.size()-1]):
			$food.position = new_rand_pos
			$score.text = 'Score:%s' % snake.body.size()
			#increase speed 
			if(snake.body.size()%5 == 0):
				$food.texture = bottle
				$Timer.wait_time = $Timer.wait_time - 0.01
				print($Timer.wait_time)
			else: 
				farr.shuffle()
				$food.texture = farr[0]
			if int(prevHighScore[1]) < snake.body.size() and once:
				$highscoreAudio.playing = true
				once = false
func draw_snake():
	#add extra body
	if(snake.body.size() > $snake.get_child_count()):
		randomize()
		var last_child = $snake.get_child($snake.get_child_count()-1).duplicate()
		last_child.modulate = Color8(randi() % 255,randi() % 255,randi() % 255);
		last_child.name = "body " + str($snake.get_child_count())
		$snake.add_child(last_child)
	#assigning snake body sprite to snake position
	for index in range(0,snake.body.size()):
		$snake.get_child(index).rect_position = snake.body[index]

func is_food_colide():
	if(snake.body[0] == $food.position):
		return true
	return false

func _input(_event):
	if Input.is_action_pressed("ui_right") and not snake.direction == Vector2(-snake.width,0):
		snake.direction = Vector2(snake.width,0)
	elif Input.is_action_pressed("ui_left")and not snake.direction == Vector2(snake.width,0):
		snake.direction = Vector2(-snake.width,0)
	elif Input.is_action_pressed("ui_down") and not snake.direction == Vector2(0,-snake.width):
		snake.direction = Vector2(0,snake.width)
	elif Input.is_action_pressed("ui_up")and not snake.direction == Vector2(0,snake.width):
		snake.direction = Vector2(0,-snake.width)

func is_game_over():
	var x = snake.body[0].x
	var y = snake.body[0].y
	if(x > window_border.x - snake.width):
		if(!infinityMode):
			return true
		snake.body[0] = Vector2(-40,y)
		return false
	elif(y > window_border.y - snake.width):
		if(!infinityMode):
			return true
		snake.body[0] = Vector2(x,-40)
		return false
	elif(x < 0):
		if(!infinityMode):
			return true
		snake.body[0] = Vector2(800, y)
		return false
	elif(y < 0):
		if(!infinityMode):
			return true
		snake.body[0] = Vector2(x,800)
		return false	
	
	if(snake.body.size() >= 3):
		for block in snake.body.slice(1,snake.body.size()):
			if(snake.body[0] == block):
				return true
	return false

func loadHS():
	var file = File.new()
	
	if not file.file_exists("res://highscore.txt"):
		return ['hs',0]
	
	file.open("res://highscore.txt", File.READ)
	print(file)
	var content = file.get_as_text()
	file.close()
	return content.split(":", true)

func _on_Timer_timeout():
	if is_game_over():
		prevHighScore = int(prevHighScore[1])
		var currScore = $score.text.split(":",true)
		if (prevHighScore < int(currScore[1])):
			var file = File.new()
			file.open("res://highscore.txt", File.WRITE)
			file.store_string($score.text)
			file.close()
		get_tree().reload_current_scene()
	snake.move()
	draw_snake()
	if(is_food_colide()):
		$AudioStreamPlayer2D.playing = true
		draw_food()
		snake.is_food_colide = true
