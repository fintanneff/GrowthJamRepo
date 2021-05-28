extends Sprite

var done = false
var starty
export(int) var score_limit

func _ready():
	ScoreTracker.updatable.push_front(self)
	starty = transform.origin.y
	transform.origin.y += 300
	modulate.a = 0
	
func on_score_update(score):
	if (score >= score_limit && !done):
		done = true

func _physics_process(delta):
	if (done):
		if (modulate.a < 0.995):
			modulate.a = lerp(modulate.a, 1, 0.005)
			transform.origin.y = lerp(transform.origin.y, starty, 0.01)
		else:
			var me = ScoreTracker.updatable.find(self)
			ScoreTracker.updatable.remove(me)
			set_script(null)
