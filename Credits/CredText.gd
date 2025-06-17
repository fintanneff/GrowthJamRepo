extends RichTextLabel
<<<<<<< Updated upstream

=======
@export var loadScores: bool = false
>>>>>>> Stashed changes

func _ready():
	var boardText = ScoreTracker.scoreMatrixToString()
	text = boardText

func _physics_process(delta):
	if (Input.is_action_just_pressed("ui_cancel") || offset_top < -200):
		get_tree().change_scene_to_file("res://TitleScreen/TitleScreen.tscn")
	else:
		offset_top -= 0.25
