extends KinematicBody2D

# Declare member variables here. Examples:
var moveSpeed = 1
var angle = Vector2(0,0)
var inputVector = Vector2(0,0)
var midshot = false

onready var animator = $AnimationPlayer
onready var sprite = $Sprite

onready var bullet = preload("res://Bullet/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Idle", -1, 1, false) 
	pass
	
func animation_done(anim_name):
	midshot = false
	
func try_animate(anim):
	if (!midshot):
		animator.play(anim, -1, 1, false)

func _physics_process(delta):
	#Wrap screen
	if (transform.origin.x < -6):
		transform.origin.x = 256 + 5
	if (transform.origin.x > 256 + 6):
		transform.origin.x = -5
	
	#Finding Controller Inputs
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if (abs(inputVector.x) > 0.5):
		sprite.scale.x = sign(-inputVector.x)
	
	#Movement Functionality
	ScoreTracker.player_last_x = transform.origin.x
	ScoreTracker.player_last_y = transform.origin.y
	if(abs(inputVector.x) > 0.5 && !Input.is_action_pressed("ui_hold")):
		if(inputVector.y < -.4):
			try_animate("WalkLeftAngled")
			angle = Vector2(sign(inputVector.x), -1)
		else:
			try_animate("WalkLeft")
			angle = Vector2(sign(inputVector.x), 0)
		move_and_collide(sign(inputVector.x) * Vector2.RIGHT * moveSpeed)
	else:
		if (inputVector.y < -.6 && abs(inputVector.x) < 0.5):
			try_animate("UpIdle")
			angle = Vector2(0, -1)
		elif (inputVector.y < -.4):
			try_animate("AngleIdle")
			angle = Vector2(-sprite.scale.x, -1)
		else:
			try_animate("Idle")
			angle = Vector2(-sprite.scale.x, 0)
			
	#Shooting
	if (Input.is_action_just_pressed("ui_shoot")):
		var newbullet = bullet.instance()
		newbullet.transform.origin.x = transform.origin.x
		newbullet.transform.origin.y = transform.origin.y
		newbullet.angleshot(angle.normalized() * 3, 0)
		get_parent().add_child(newbullet)
		midshot = true
		if (angle.y < -.4 && abs(inputVector.x) > 0.5):
			animator.play("AngleShoot", -1, 1, false)
		elif (angle.y < -.4):
			animator.play("UpShoot", -1, 1, false)
		else:
			animator.play("LeftShoot", -1, 1, false)


func _on_Area2D_body_entered(body):
	queue_free()
