extends Sprite

var ifade = 0

func set_ifade(val):
	ifade = val
	
func hard_set_fade(val):
	ifade = val
	modulate.a = val
	
func _physics_process(delta):
	if (modulate.a != ifade):
		modulate.a = lerp(modulate.a, ifade, 0.01)
