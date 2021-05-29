extends Node2D





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _input(event):
	
	if event.is_action_pressed("Pause"):
		
		if(ScoreTracker.player_dead != true && get_tree().get_current_scene().get_name() == "Main"):
			get_tree().paused = !get_tree().paused
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
