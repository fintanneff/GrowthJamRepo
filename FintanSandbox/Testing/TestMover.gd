extends KinematicBody2D

func _ready():
	pass

func _process(delta):
	var inp = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	move_and_collide(inp * delta * 30);
	pass
