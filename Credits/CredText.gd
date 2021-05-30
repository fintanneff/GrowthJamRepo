extends RichTextLabel


func _physics_process(delta):
	if (Input.is_action_just_pressed("ui_cancel") || margin_top < -394):
		get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")
	else:
		margin_top -= 0.25
