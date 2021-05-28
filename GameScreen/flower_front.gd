extends Sprite

onready var stem = get_parent().get_child(1)

func _ready():
	modulate.r = rand_range(0, 1)
	modulate.g = rand_range(0, 1)
	modulate.b = rand_range(0, 1)
	var flip = rand_range(0, 1)
	if (flip > 0.5):
		stem.z_index = 1
		z_index = 2
