extends Sprite

var iPos = Vector2.ZERO
var menuNum = 0

export (Vector2) var gamePos
export (Vector2) var creditPos
export (Vector2) var exitPos


func _physics_process(delta):
	
	if(Input.is_action_just_pressed("ui_up")):
		menuNum -= 1
		if (menuNum < 0):
			menuNum = 2
		cursorChange()
	if(Input.is_action_just_pressed("ui_down")):
		menuNum += 1
		if(menuNum > 2):
			menuNum = 0
		cursorChange()
	
	transform.origin = lerp(transform.origin,iPos,0.1)
	
	if(Input.is_action_just_pressed("ui_shoot")):
		cursorPress()
	pass



# Called when the node enters the scene tree for the first time.
func _ready():
	cursorChange()
	pass # Replace with function body.




func cursorChange():
	if(menuNum == 0):
		iPos = gamePos
	elif(menuNum == 1):
		iPos = creditPos
	elif(menuNum == 2):
		iPos = exitPos
	pass

func cursorPress():
	if(menuNum == 0):
		get_tree().change_scene("res://FintanSandbox/FintanTestScene.tscn")

