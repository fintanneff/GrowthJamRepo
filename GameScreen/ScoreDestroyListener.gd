extends Node2D

@export var score_limit: int

func _ready():
	ScoreTracker.updatable.push_front(self)
	
func on_score_update(score):
	if (score >= score_limit):
		var pos = ScoreTracker.updatable.find(self)
		ScoreTracker.updatable.remove_at(pos)
		queue_free()
