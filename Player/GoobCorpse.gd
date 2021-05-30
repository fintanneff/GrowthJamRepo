extends Sprite

var vely = -2
onready var bs = $based_sound
onready var cs = $cringe_sound

func _ready():
	var roll = rand_range(0, 200)
	if (roll < 2):
		bs.play()
	else:
		cs.play()
	scale = Vector2.ONE * 2

func _physics_process(delta):
	transform.origin.y += vely
	vely += 0.075
	if (transform.origin.y > 200):
		queue_free()
	scale = lerp(scale, Vector2.ONE, 0.1)
