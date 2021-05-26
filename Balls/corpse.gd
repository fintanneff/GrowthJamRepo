extends Sprite

var timer = 5
var vel = Vector2.ZERO
var rot = 0

func _physics_process(delta):
	if (timer <= 0):
		queue_free()
	else:
		timer -= 1
	transform.origin.x += vel.rotated(rot).x
	transform.origin.y += vel.rotated(rot).y
	scale = lerp(scale, Vector2.ZERO, 0.1)
	
func angle(v, a, t, s1):
	scale = s1
	vel = v
	rot = a
	timer = t
