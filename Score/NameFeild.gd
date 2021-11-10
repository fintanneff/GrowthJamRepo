extends RichTextLabel

var currentChar = 0
var currentSelection = 0

func _ready():
	replaceCurrentChar()

func _physics_process(delta):
	if(Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_dpadup")):
		flick(1)
	if(Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_dpaddown")):
		flick(-1)
	if (Input.is_action_just_pressed("ui_Xleft")):
		nextChar()
	if (Input.is_action_just_pressed("ui_Yup")):
		clearAll()

func flick(number):
	currentSelection += number
	if (currentSelection > 25):
		currentSelection = 0
	if (currentSelection < 0):
		currentSelection = 25
	replaceCurrentChar()
	
func nextChar():
	currentChar += 1
	print (currentChar)
	if (currentChar < 6):
		replaceCurrentChar()
	else:
		ScoreTracker.scoreMatrix[ScoreTracker.rankToReplace][1] = text
		ScoreTracker.saveScoreMatrix()
		get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")

func clearAll():
	text = "______"
	currentChar = 0
	currentSelection = 0
	replaceCurrentChar()

func replaceCurrentChar():
	var theChar = "A"
	match currentSelection:
		0:
			theChar = "A"
		1:
			theChar = "B"
		2:
			theChar = "C"
		3:
			theChar = "D"
		4:
			theChar = "E"
		5:
			theChar = "F"
		6:
			theChar = "G"
		7:
			theChar = "H"
		8:
			theChar = "I"
		9:
			theChar = "J"
		10:
			theChar = "K"
		11:
			theChar = "L"
		12:
			theChar = "M"
		13:
			theChar = "N"
		14:
			theChar = "O"
		15:
			theChar = "P"
		16:
			theChar = "Q"
		17:
			theChar = "R"
		18:
			theChar = "S"
		19:
			theChar = "T"
		20:
			theChar = "U"
		21:
			theChar = "V"
		22:
			theChar = "W"
		23:
			theChar = "X"
		24:
			theChar = "Y"
		25:
			theChar = "Z"
	text[currentChar] = theChar
