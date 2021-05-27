extends Node2D

var score = 0
var updatable = []
#---------
#ARRAYS FOR BALLS!!!
var current_round = []
var misc_balls = []
#---------
var misc_ball_countdown = -1
var misc_ball_reset_time = 160
var round_ball_countdown = -1
var round_ball_reset_time = 1000

var round_volume = 5
var max_balls = 15

var player_last_x = 0
var player_last_y = 0

onready var small_balloon = preload("res://Balls/SmallBall.tscn")
onready var med_balloon = preload("res://Balls/BullyBall.tscn")
onready var large_balloon = preload("res://Balls/StarBall.tscn")

var internal_d12 = 1

func roll_internal_d12():
	internal_d12 = int(rand_range(1, 12))

func _physics_process(delta):
	if (misc_ball_countdown != -1):
		if (misc_ball_countdown > 0):
			misc_ball_countdown -= 1
		else:
			misc_ball_countdown = misc_ball_reset_time
			misc_ball_spawn()
	if (round_ball_countdown != -1):
		if (round_ball_countdown > 0):
			round_ball_countdown -= 1
		else:
			round_ball_countdown = round_ball_reset_time
			new_round()

func begin_misc_ball_timer():
	misc_ball_countdown = misc_ball_reset_time
	
func begin_round_timer():
	round_ball_countdown = round_ball_reset_time

func increase_score(s):
	score += s
	print(score)
	for i in updatable:
		i.on_score_update(score)
	if (misc_ball_countdown == -1 && score >= 100):
		begin_misc_ball_timer()
	if (round_ball_countdown == -1 && score >= 500):
		begin_round_timer()
	if (score >= 10000):
		misc_ball_reset_time = 125
		round_ball_reset_time = 700
		max_balls = 17
		round_volume = 7
	elif (score >= 5000):
		round_ball_reset_time = 800
		max_balls = 16
		round_volume = 6
	elif (score >= 1000):
		misc_ball_reset_time = 150
		round_volume = 5

#Called from balloons when they try to add themselved to the current round
func spawn_check(b, part_of_round):
	if (current_round.size() + misc_balls.size() < max_balls):
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
	else:
		bpos = misc_balls.find(b, 0)
		if (bpos != -1):
			misc_balls.remove(bpos)
	
func misc_ball_spawn():
	var newball
	roll_internal_d12()
	if (internal_d12 >= 10):
		if (score >= 5000):
			newball = large_balloon.instance()
		else:
			newball = med_balloon.instance()
	elif (internal_d12 >= 7):
		if (score >= 500):
			newball = med_balloon.instance()
		else:
			newball = small_balloon.instance()
	else:
		newball = small_balloon.instance()
	var worked = spawn_check(newball, false)
	if (worked):
		newball.transform.origin.x = rand_range(32, 224)
		newball.transform.origin.y = rand_range(-16, -64)
		get_tree().get_root().get_node("Main").call_deferred("add_child", newball)

#Called every new round (when all balloons have been popped)
func new_round():
	#print("NEW ROUND!")
	for i in range(round_volume):
		var newball
		roll_internal_d12()
		if (internal_d12 >= 8):
			if (score >= 10000):
				newball = med_balloon.instance()
			else:
				newball = small_balloon.instance()
		else:
			newball = small_balloon.instance()
		var worked = spawn_check(newball, true)
		if (worked):
			newball.transform.origin.x = rand_range(32, 224)
			newball.transform.origin.y = rand_range(-16, -64)
			get_tree().get_root().get_node("Main").call_deferred("add_child", newball)
