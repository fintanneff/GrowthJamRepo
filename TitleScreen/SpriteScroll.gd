extends Sprite

func _ready():
	region_enabled = true
	region_rect.position.x = 0
	region_rect.position.y = 0
	region_rect.size.x = 256
	region_rect.size.y = 176

func _physics_process(delta):
	region_rect.position.x += 0.1
	region_rect.position.y += 0.1
