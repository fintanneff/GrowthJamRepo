extends Sprite

var iPos = Vector2.ZERO
var menuNum = 0

var menustate = 0

onready var menu1 = get_parent().get_node("Menu1")
onready var menu2 = get_parent().get_node("Menu2")
onready var control_display = get_parent().get_node("Menu2").get_node("classic_vs_modern")
onready var menuMusic = get_parent().get_node("AudioStreamPlayer")
onready var soundText = get_parent().get_node("Menu1").get_node("SoundText")

onready var menuSelect = get_parent().get_node("select")
onready var menuMove = get_parent().get_node("move")
onready var zoomin = get_parent().get_node("zoomin")

export (Vector2) var gamePos
export (Vector2) var highScorePos
export (Vector2) var creditPos
export (Vector2) var soundPos
export (Vector2) var exitPos

export (Vector2) var classicControlPos
export (Vector2) var modernControlPos

var animtimer = 30
var waittimertickdown = false
var waittimer = 80

func big_reset():
	menu1.visible = true
	menu2.visible = false
	menustate = 0
	menuNum = 0
	

func menu_main():
	if(Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_dpadup")):
		menuNum -= 1
		if (menuNum < 0):
			menuNum = 4
		print(menuNum)
	if(Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_dpaddown")):
		menuNum += 1
		if(menuNum > 4):
			menuNum = 0
		print(menuNum)
	if(menuNum == 0):
		iPos = gamePos
	elif(menuNum == 1):
		iPos = highScorePos
	elif(menuNum == 2):
		iPos = creditPos
	elif(menuNum == 3):
		iPos = soundPos
	elif(menuNum == 4):
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
		print(menuNum)
	if(Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_dpaddown")):
		menuNum += 1
		if(menuNum > 1):
			menuNum = 0
		print(menuNum)
	if(menuNum == 0):
		iPos = classicControlPos
		control_display.frame = 0
	elif(menuNum == 1):
		iPos = modernControlPos
		control_display.frame = 1
	
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
		waittimer -= 1
		if(waittimer < 1 || Input.is_action_just_pressed("ui_shoot") || Input.is_action_just_pressed("ui_Xleft")):
			print("hello_world")
			timerEnd()


# Called when the node enters the scene tree for the first time.
func _ready():
	if (!ScoreTracker.game_music_mode):
		ScoreTracker.game_music_mode = false
		soundText.text = "Music Off"
		menuMusic.volume_db = -80
	else:
		ScoreTracker.game_music_mode = true
		soundText.text = "Music On"
		menuMusic.volume_db = 0
	randomize()
	iPos = gamePos


func cursorPress():
	if (menustate == 0):
		menuSelect.play()
		if(menuNum == 0):
			menustate = 1
			menu1.visible = false
			menu2.visible = true
			menuNum = 1
		elif(menuNum == 1):
			get_tree().change_scene("res://Score/HighScore.tscn")
			print("GOING TO HIGHSCORE")
		elif(menuNum == 2):
			get_tree().change_scene("res://Credits/Credits.tscn")
			print("GOING TO CREDS")
		elif (menuNum == 3):
			if (soundText.text == "Music On"):
				ScoreTracker.game_music_mode = false
				soundText.text = "Music Off"
				menuMusic.volume_db = -80
			else:
				ScoreTracker.game_music_mode = true
				soundText.text = "Music On"
				menuMusic.volume_db = 0
		if(menuNum == 4):
			get_tree().quit()
	elif (menustate == 1):
		if(menuNum == 0):
			ScoreTracker.player_control_mode = false
			ScreenFader.anim_out_of_title()
			waittimertickdown = true
			menuMusic.volume_db = -80
			zoomin.play()
		if(menuNum == 1):
			ScoreTracker.player_control_mode = true
			ScreenFader.anim_out_of_title()
			waittimertickdown = true
			menuMusic.volume_db = -80
			zoomin.play()
		
func timerEnd():
	ScreenFader.play_zoomy_sound()
	if(menustate == 1):
		ScreenFader.anim_into_game()
		get_tree().change_scene("res://FintanSandbox/FintanTestScene.tscn")
	else:
		ScreenFader.anim_into_game()
		get_tree().change_scene("res://FintanSandbox/FintanTestScene.tscn")

