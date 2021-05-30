extends KinematicBody2D

# Declare member variables here. Examples:
var moveSpeed = 1
var angle = Vector2(0,0)
var inputVector = Vector2(0,0)
var inputVectorWASD = Vector2(0,0)
var inputVectorDPAD = Vector2(0,0)
var inputVectorBUTTONS = Vector2(0,0)
var midshot = false

onready var animator = $AnimationPlayer
onready var sprite = $Sprite

onready var shootsoundplayer = $ShootSoundPlayer

onready var bullet = preload("res://Bullet/Bullet.tscn")
onready var corpse = preload("res://Bullet/Bullet.tscn")
onready var gameovertext = preload("res://GameScreen/GameOverText.tscn")
onready var goobcorpse = preload("res://Player/GoobCorpse.tscn")

var autofire_timer = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	#ScreenFader.hard_set_fade(1)
	ScreenFader.set_ifade(0)
	animator.play("Idle", -1, 1, false) 
	pass
	
func animation_done(anim_name):
	midshot = false
	
func try_animate(anim):
	if (!midshot):
		animator.play(anim, -1, 1, false)

func input_move_wasd():
	var movevec = Vector2.ZERO
	movevec.x = clamp(inputVectorWASD.x+inputVectorDPAD.x, -1, 1)
	movevec.y = clamp(inputVectorWASD.y+inputVectorDPAD.y, -1, 1)
	var shootvec = Vector2.ZERO
	shootvec.x = clamp(inputVector.x+inputVectorBUTTONS.x, -1, 1)
	shootvec.y = clamp(inputVector.y+inputVectorBUTTONS.y, -1, 1)
	var moving = false
	var anglestate = 0
	#Moving
	if (abs(movevec.x) > 0.5):
		move_and_collide(sign(movevec.x) * Vector2.RIGHT * moveSpeed)
		moving = true
		if (abs(shootvec.x) < 0.5):
			sprite.scale.x = sign(-movevec.x)
	#Movement Functionality with WASD
	ScoreTracker.player_last_x = transform.origin.x
	ScoreTracker.player_last_y = transform.origin.y
	#Look left/right with arrows
	if (abs(shootvec.x) > 0.6):
		angle.x = sign(shootvec.x)
		sprite.scale.x = sign(-angle.x)
	else:
		angle.x = 0
	#Look up/down with arrows
	if (shootvec.y < -0.4):
		angle.y = -1
	else:
		angle.y = 0
	#Play the proper animation
	if (!moving && angle.y < -.4 && abs(angle.x) > 0.5):
		try_animate("AngleIdle")
		anglestate = 1
	elif (!moving && angle.y < -.4):
		try_animate("UpIdle")
		anglestate = 2
	elif (!moving):
		try_animate("Idle")
		anglestate = 0
	elif (moving && angle.y < -.4 && abs(angle.x) > 0.5):
		try_animate("WalkLeftAngled")
		anglestate = 1
	elif (moving && angle.y < -.4):
		try_animate("WalkLeftUp")
		anglestate = 2
	elif (moving):
		try_animate("WalkLeft")
		anglestate = 0
	#Shooting
	#if (Input.is_action_just_pressed("ui_shoot") || angle.length() > 0.1):
	if (angle.length() > 0.1):
		if (autofire_timer < 1):
			autofire_timer = 10
			shootsoundplayer.play()
			var newbullet = bullet.instance()
			newbullet.transform.origin.x = transform.origin.x
			newbullet.transform.origin.y = transform.origin.y
			newbullet.angleshot(angle.normalized() * 3, 0)
			get_parent().add_child(newbullet)
			midshot = true
			if (angle.y < -.4 && abs(angle.x) > 0.5):
				animator.play("AngleShoot", -1, 1.4, false)
			elif (angle.y < -.4):
				animator.play("UpShoot", -1, 1.4, false)
			else:
				animator.play("LeftShoot", -1, 1.4, false)
		else:
			autofire_timer -= 1
	else:
		autofire_timer = 0
	
func input_move_arrow():
	var movevec = Vector2.ZERO
	movevec.x = clamp(inputVector.x+inputVectorDPAD.x, -1, 1)
	movevec.y = clamp(inputVector.y+inputVectorDPAD.y, -1, 1)
	#Moving
	if (abs(movevec.x) > 0.5):
		sprite.scale.x = sign(-movevec.x)
	#Movement Functionality
	ScoreTracker.player_last_x = transform.origin.x
	ScoreTracker.player_last_y = transform.origin.y
	if(abs(movevec.x) > 0.5 && !(Input.is_action_pressed("ui_hold")||Input.is_action_just_pressed("ui_Adown")) ):
		if(movevec.y < -.4):
			try_animate("WalkLeftAngled")
			angle = Vector2(sign(movevec.x), -1)
		else:
			try_animate("WalkLeft")
			angle = Vector2(sign(movevec.x), 0)
		move_and_collide(sign(movevec.x) * Vector2.RIGHT * moveSpeed)
	else:
		if (movevec.y < -.6 && abs(movevec.x) < 0.5):
			try_animate("UpIdle")
			angle = Vector2(0, -1)
		elif (movevec.y < -.4):
			try_animate("AngleIdle")
			angle = Vector2(-sprite.scale.x, -1)
		else:
			try_animate("Idle")
			angle = Vector2(-sprite.scale.x, 0)
	#Shooting
	if (Input.is_action_just_pressed("ui_shoot") || Input.is_action_just_pressed("ui_Xleft")):
		shootsoundplayer.play()
		var newbullet = bullet.instance()
		newbullet.transform.origin.x = transform.origin.x
		newbullet.transform.origin.y = transform.origin.y
		newbullet.angleshot(angle.normalized() * 3, 0)
		get_parent().add_child(newbullet)
		midshot = true
		if (angle.y < -.4 && abs(movevec.x) > 0.5):
			animator.play("AngleShoot", -1, 1.4, false)
		elif (angle.y < -.4):
			animator.play("UpShoot", -1, 1.4, false)
		else:
			animator.play("LeftShoot", -1, 1.4, false)

func _physics_process(delta):
	#Finding Controller Inputs
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVectorWASD.x = Input.get_action_strength("ui_dright") - Input.get_action_strength("ui_aleft")
	inputVectorWASD.y = Input.get_action_strength("ui_sdown") - Input.get_action_strength("ui_wup")
	inputVectorDPAD.x = Input.get_action_strength("ui_dpadright") - Input.get_action_strength("ui_dpadleft")
	inputVectorDPAD.y = Input.get_action_strength("ui_dpaddown") - Input.get_action_strength("ui_dpadup")
	inputVectorBUTTONS.x = Input.get_action_strength("ui_Bright") - Input.get_action_strength("ui_Xleft")
	inputVectorBUTTONS.y = Input.get_action_strength("ui_Adown") - Input.get_action_strength("ui_Yup")
	#Wrap screen
	if (transform.origin.x < -6):
		transform.origin.x = 256 + 5
	if (transform.origin.x > 256 + 6):
		transform.origin.x = -5
	if (ScoreTracker.player_control_mode):
		input_move_wasd()
	else:
		input_move_arrow()
	#Quick exit to title
	if (Input.is_action_just_pressed("ui_cancel")):
			ScoreTracker.set_me_up()
			ScreenFader.hard_set_fade(0.7)
			ScreenFader.set_ifade(0)
			get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")


func _on_Area2D_body_entered(body):
	for i in get_parent().get_children():
		if i.has_method("death_react"):
			i.death_react()
	#ScoreTracker.set_me_up()
	#get_tree().reload_current_scene()
	var corpse = goobcorpse.instance()
	corpse.transform.origin = transform.origin
	get_parent().add_child(corpse)
	queue_free()
	ScreenFader.set_ifade(0.7)
	ScoreTracker.player_dead = true
	var newtext = gameovertext.instance()
	get_parent().add_child(newtext)
	pass
