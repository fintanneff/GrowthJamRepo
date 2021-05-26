extends Node2D

var score = 0
var updatable = []
var current_round = []
var misc_balls = []
var misc_ball_countdown = 200

var player_last_x = 0
var player_last_y = 0

onready var small_balloon = preload("res://Balls/SmallBall.tscn")
onready var med_balloon = preload("res://Balls/BullyBall.tscn")
onready var large_balloon = preload("res://Balls/StarBall.tscn")

func _physics_process(delta):
	if (misc_ball_countdown > 0):
		misc_ball_countdown -= 1
	else:
		misc_ball_countdown = 200
		misc_ball_spawn()

func increase_score(s):
	score += s
	print(score)
	for i in updatable:
		i.on_score_update(score)

#Called from balloons when they try to add themselved to the current round
func spawn_check(b, part_of_round):
	if (current_round.size() + misc_balls.size() < 20):
		if (part_of_round):
			current_round.push_front(b)
		else:
			misc_balls.push_front(b)
		return true
	else:
		b.queue_free()
		return false

#Called from balloons when they are popped
func pop_check(b):
	var bpos = current_round.find(b, 0)
	if (bpos != -1):
		current_round.remove(bpos)
		if (current_round.size() <= 0):
			new_round()
	else:
		bpos = misc_balls.find(b, 0)
		misc_balls.remove(bpos)
	
func misc_ball_spawn():
	var newball = small_balloon.instance()
	var worked = spawn_check(newball, false)
	if (worked):
		newball.transform.origin.x = rand_range(32, 224)
		newball.transform.origin.y = rand_range(-16, -64)
		get_tree().get_root().get_node("Main").call_deferred("add_child", newball)

#Called every new round (when all balloons have been popped)
func new_round():
	print("NEW ROUND!")
	for i in range(10):
		var newball = small_balloon.instance()
		var worked = spawn_check(newball, true)
		if (worked):
			newball.transform.origin.x = rand_range(32, 224)
			newball.transform.origin.y = rand_range(-16, -64)
			get_tree().get_root().get_node("Main").call_deferred("add_child", newball)
