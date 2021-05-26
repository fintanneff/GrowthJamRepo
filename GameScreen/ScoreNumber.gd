extends RichTextLabel

func _ready():
	ScoreTracker.updatable.push_front(self)

func on_score_update(score):
	text = str(score)
