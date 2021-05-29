extends Sprite

var iPos = Vector2.ZERO
var menuNum = 0

var menustate = 0

onready var menu1 = get_parent().get_node("Menu1")
onready var menu2 = get_parent().get_node("Menu2")

export (Vector2) var gamePos
export (Vector2) var creditPos
export (Vector2) var exitPos

export (Vector2) var classicControlPos
export (Vector2) var modernControlPos

var animtimer = 30
var waittimertickdown = false

func big_reset():
	menu1.visible = true
	menu2.visible = false
	menustate = 0
	menuNum = 0
	

func menu_main():
	if(Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_dpadup")):
		menuNum -= 1
		if (menuNum < 0):
			menuNum = 2
	if(Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_dpaddown")):
		menuNum += 1
		if(menuNum > 2):
			menuNum = 0
	if(menuNum == 0):
		iPos = gamePos
	elif(menuNum == 1):
		iPos = creditPos
	elif(menuNum == 2):
		iPos = exitPos
	
	transform.origin = lerp(transform.origin,iPos,0.1)
	
	if(Input.is_action_just_pressed("ui_shoot") || Input.is_action_just_pressed("ui_Xleft")):
		cursorPress()
	
	if (animtimer > 0):
		animtimer -= 1
	else:
		animtimer = 5
		if (frame+1 > 3):
			frame = 0
		else:
			frame += 1


func menu_control():
	if(Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_dpadup")):
		menuNum -= 1
		if (menuNum < 0):
			menuNum = 1
	if(Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_dpaddown")):
		menuNum += 1
		if(menuNum > 1):
			menuNum = 0
	if(menuNum == 0):
		iPos = classicControlPos
	elif(menuNum == 1):
		iPos = modernControlPos
	
	transform.origin = lerp(transform.origin,iPos,0.1)
	
	if(Input.is_action_just_pressed("ui_shoot") || Input.is_action_just_pressed("ui_Xleft")):
		cursorPress()
	
	if (animtimer > 0):
		animtimer -= 1
	else:
		animtimer = 5
		if (frame+1 > 3):
			frame = 0
		else:
			frame += 1

func _physics_process(delta):
	if (Input.is_action_just_pressed("ui_hold") || Input.is_action_just_pressed("ui_Adown")):
		big_reset()
	if (!waittimertickdown):
		if (menustate == 0):
			menu_main()
		elif (menustate == 1):
			menu_control()
	else:
		if(Input.is_action_just_pressed("ui_shoot") || Input.is_action_just_pressed("ui_Xleft")):
			timerEnd()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	iPos = gamePos
	


func cursorPress():
	if (menustate == 0):
		if(menuNum == 0):
			menustate = 1
			menu1.visible = false
			menu2.visible = true
	elif (menustate == 1):
		if(menuNum == 0):
			ScoreTracker.player_control_mode = false
			ScreenFader.anim_out_of_title()
			waittimertickdown = true
		if(menuNum == 1):
			ScoreTracker.player_control_mode = true
			ScreenFader.anim_out_of_title()
			waittimertickdown = true
		
func timerEnd():
	if(menustate == 1):
		ScreenFader.anim_into_game()
		get_tree().change_scene("res://FintanSandbox/FintanTestScene.tscn")
		waittimertickdown = true

