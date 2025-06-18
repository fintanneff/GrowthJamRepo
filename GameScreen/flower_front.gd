extends Sprite2D

@onready var stem = get_parent().get_child(1)

func _ready():
	modulate.r = randf_range(0, 1)
	modulate.g = randf_range(0, 1)
	modulate.b = randf_range(0, 1)
	var flip = randf_range(0, 1)
	if (flip > 0.5):
		stem.z_index = 1
		z_index = 2
