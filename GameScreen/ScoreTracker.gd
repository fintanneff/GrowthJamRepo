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
var max_balls = 10

var player_last_x = 0
var player_last_y = 0
var player_dead = false

var player_control_mode = false

onready var small_balloon = preload("res://Balls/SmallBall.tscn")
onready var med_balloon = preload("res://Balls/BullyBall.tscn")
onready var large_balloon = preload("res://Balls/StarBall.tscn")

onready var explodeSound = $ExplodePlayer

var internal_d12 = 1

#func _ready():
#	call_deferred("set_me_up")

func set_me_up():
	score = 0
	misc_ball_countdown = -1
	misc_ball_reset_time = 160
	round_ball_countdown = -1
	round_ball_reset_time = 1000
	round_volume = 4
	max_balls = 8
	player_last_x = 0
	player_last_y = 0
	updatable.clear()
	misc_balls.clear()
	current_round.clear()
	player_dead = false

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
	for i in updatable:
		i.on_score_update(score)
	score_progress_table()

func score_progress_table():
	if (misc_ball_countdown == -1 && score >= 100):
		begin_misc_ball_timer()
	if (round_ball_countdown == -1 && score >= 500):
		begin_round_timer()
	elif (score >= 50000):
		round_ball_reset_time = 300
	elif (score >= 40000):
		round_ball_reset_time = 450
	elif (score >= 30000):
		misc_ball_reset_time = 30
		round_ball_reset_time = 500
		max_balls = 20
		round_volume = 10
	elif (score >= 25000):
		misc_ball_reset_time = 50
		round_ball_reset_time = 550
	elif (score >= 20000):
		misc_ball_reset_time = 70
		round_ball_reset_time = 600
		max_balls = 18
	elif (score >= 15000):
		misc_ball_reset_time = 100
		round_ball_reset_time = 650
		max_balls = 15
	elif (score >= 10000):
		misc_ball_reset_time = 125
		round_ball_reset_time = 700
		max_balls = 12
	elif (score >= 5000):
		round_ball_reset_time = 800
		max_balls = 9
		round_volume = 6
	elif (score >= 1000):
		misc_ball_reset_time = 150
		round_volume = 4

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

func playExplodeSound():
	explodeSound.play()
