extends Node2D

var waittimer = 50

func _ready():
	transform.origin.y += 100
	pass


func _physics_process(delta):
	if (waittimer > 0):
		waittimer -= 1
	else:
		transform.origin.y = lerp(transform.origin.y, 0, 0.05)
		if (Input.is_action_just_released("ui_shoot") || Input.is_action_just_released("ui_Xleft")):
			ScoreTracker.set_me_up()
			ScreenFader.hard_set_fade(1)
			get_tree().reload_current_scene()
		if (Input.is_action_just_released("ui_hold") || Input.is_action_just_released("ui_Adown")):
			ScoreTracker.set_me_up()
			ScreenFader.hard_set_fade(1)
			ScreenFader.set_ifade(0)
			get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")
