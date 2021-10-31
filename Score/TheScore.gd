extends RichTextLabel

func _ready():
	text = str(ScoreTracker.scoreToReplaceWith)
	ScoreTracker.set_me_up()
