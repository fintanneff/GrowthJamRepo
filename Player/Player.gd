extends KinematicBody2D


# Declare member variables here. Examples:
var moveSpeed = 1
var angle = Vector2(0,0)
var inputVector = Vector2(0,0)
var animationState = 0

onready var animator = $AnimationPlayer
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Idle", -1, 1, false) 
	
	
	pass 



func _physics_process(delta):
	#Finding Controller Inputs
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#Movement Functionality
	if(abs(inputVector.x) > 0.5):
		sprite.scale.x = sign(-inputVector.x)
		
		if(inputVector.y < -.4):
			if(animationState != 4):
				animationState = 4
				animator.play("WalkLeftAngled", -1, 1, false)
				pass
			pass
		else:
			if(animationState != 1):
				animationState = 1
				animator.play("WalkLeft", -1, 1, false)
				pass
		
		move_and_collide(sign(inputVector.x) * Vector2.RIGHT * moveSpeed)
		
	else:
		if(animationState != 0):
			animationState = 0
			animator.play("Idle", -1, 1, false)
			pass
		 
	
	
	pass
