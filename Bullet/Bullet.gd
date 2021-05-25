extends Area2D

var vel = Vector2.ZERO
var rot = 0.0
var dedtimer = 60

onready var hit = $Hit

func _physics_process(delta):
	if (dedtimer <= 0):
		queue_free()
	else:
		dedtimer -= 1
	transform.origin.x += vel.rotated(rot).x
	transform.origin.y += vel.rotated(rot).y

func angleshot(v, r):
	vel = v
	rot = r
