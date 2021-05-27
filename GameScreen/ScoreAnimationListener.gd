extends Node2D

onready var anim = $AnimationPlayer
var done = false
export(int) var score_limit

func _ready():
	ScoreTracker.updatable.push_front(self)
	
func on_score_update(score):
	if (score >= score_limit && !done):
		done = true
		anim.play("FallAway", -1, 1, false)
