extends KinematicBody2D

func _ready():
	pass

func _physics_process(delta):
	var inp = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0
	)
	move_and_collide(inp);
	pass
