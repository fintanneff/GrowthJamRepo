extends Sprite2D

var timeout = 20

func setframe(f):
	frame = f

func _physics_process(delta):
	timeout -= 1
	if (timeout < 1):
		queue_free()
