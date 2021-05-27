extends Node2D

export(int) var score_limit

func _ready():
	ScoreTracker.updatable.push_front(self)
	
func on_score_update(score):
	if (score >= score_limit):
		var pos = ScoreTracker.updatable.find(self)
		ScoreTracker.updatable.remove(pos)
		queue_free()
