extends Node2D

onready var anim = $AnimationPlayer
var done = false
export(int) var score_limit
export(String) var anim_name

func _ready():
	ScoreTracker.updatable.push_front(self)
	
func on_score_update(score):
	if (score >= score_limit && !done):
		done = true
		anim.play(anim_name, -1, 1, false)
