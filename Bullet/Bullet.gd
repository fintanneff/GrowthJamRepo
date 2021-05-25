extends Area2D

var vel = Vector2.ZERO
var rot = 0.0

onready var hit = $Hit

func _physics_process(delta):
	if (transform.origin.x > 256 || transform.origin.x < 0):
		queue_free()
	if (transform.origin.y > 176 || transform.origin.y < 0):
		queue_free()
	transform.origin.x += vel.rotated(rot).x
	transform.origin.y += vel.rotated(rot).y

func angleshot(v, r):
	vel = v
	rot = r
