extends Sprite

var vely = -2

func _ready():
	
	scale = Vector2.ONE * 2

func _physics_process(delta):
	transform.origin.y += vely
	vely += 0.075
	if (transform.origin.y > 200):
		queue_free()
	scale = lerp(scale, Vector2.ONE, 0.1)
