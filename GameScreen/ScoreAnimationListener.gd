extends Node2D

@onready var anim = $AnimationPlayer
var done = false
@export var score_limit: int
@export var anim_name: String

func _ready():
	ScoreTracker.updatable.push_front(self)
	
func on_score_update(score):
	if (score >= score_limit && !done):
		done = true
		anim.play(anim_name, -1, 1, false)
