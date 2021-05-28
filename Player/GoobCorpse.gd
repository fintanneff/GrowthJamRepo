extends Sprite

var vely = -1

func _ready():
	scale = Vector2.ONE * 1.5

func _physics_process(delta):
	transform.origin.y += vely
	vely += 0.1
	if (transform.origin.y > 200):
		queue_free()
	scale = lerp(scale, Vector2.ONE, 0.5)
