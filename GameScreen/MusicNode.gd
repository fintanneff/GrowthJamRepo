extends Node2D

onready var drum = $Drum
var drum_ivolume = -80
onready var bass = $Bass
var bass_ivolume = -80
onready var echo = $Echo
var echo_ivolume = -80
onready var ice = $Ice
var ice_ivolume = -80

func _ready():
	if (ScoreTracker.game_music_mode):
		ScoreTracker.updatable.push_front(self)
	else:
		set_script(null)
	
func on_score_update(score):
	if (!ScoreTracker.player_dead):
		if (score >= 3000): drum_ivolume = 0
		if (score >= 15000): bass_ivolume = 0
		if (score >= 25000): echo_ivolume = 0
		if (score >= 8000): ice_ivolume = 0
	
func death_react():
	drum_ivolume = -80
	bass_ivolume = -80
	echo_ivolume = -80
	ice_ivolume = -80
	drum.volume_db = -80
	bass.volume_db = -80
	echo.volume_db = -80
	ice.volume_db = -80

func _process(delta):
	#drum.volume_db = lerp(drum_ivolume, 0, 0.0001 * delta)
	if (drum.volume_db < drum_ivolume): drum.volume_db += delta * 3
	#bass.volume_db = lerp(bass_ivolume, 0, 0.0001 * delta)
	if (bass.volume_db < bass_ivolume): bass.volume_db += delta * 3
	#echo.volume_db = lerp(echo_ivolume, 0, 0.0001 * delta)
	if (echo.volume_db < echo_ivolume): echo.volume_db += delta * 3
	#ice.volume_db = lerp(ice_ivolume, 0, 0.0001 * delta)
	if (ice.volume_db < ice_ivolume): ice.volume_db += delta * 3
