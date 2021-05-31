extends Sprite

var ifade = 0

onready var lscreen = $loadscreen
onready var fscreen = $fadescreen
onready var animplayer = $AnimationPlayer
onready var zoomysound = $zoomout

func _ready():
	lscreen.scale = Vector2.ZERO
	fscreen.modulate.a = 0
	pass

func set_ifade(val):
	ifade = val
	
func hard_set_fade(val):
	ifade = val
	fscreen.modulate.a = val
	
func _physics_process(delta):
	if (fscreen.modulate.a != ifade):
		fscreen.modulate.a = lerp(fscreen.modulate.a, ifade, 0.007)

func anim_out_of_title():
	animplayer.play("grow", -1, 1, false)
	
func anim_into_game():
	animplayer.play("shrink", -1, 1, false)
	
func play_zoomy_sound():
	zoomysound.play()
