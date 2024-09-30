extends Node

const BUG_COLLECTED = "BugCollected"
const MENU_SELECT = "MenuSelect"
const MENU_CHOOSE = "MenuChoose"
const VB_ACCEPTED = "VBAccepted"
const VB_DISMISSED = "VBDismissed"
const VB_COUNT = "VBCount"
const MUSIC_BG = "BGMusic"
const LEVEL_COMPLETE = "level_complete"
const GAME_OVER = "game_over"
const LOSE_POINTS = "lose points"
const PHONE_RING = "phone_ring"

var SOUNDS = {
	#BUG_COLLECTED: preload("res://assets/sounds/bug_collected.wav"),
	MUSIC_BG: preload("res://assets/music/GenMegaActionMP3.mp3"),
	BUG_COLLECTED: preload("res://assets/sounds/kick.wav"),
	MENU_CHOOSE: preload("res://assets/sounds/menu_choose.wav"),
	MENU_SELECT: preload("res://assets/sounds/menu_select.wav"),
	VB_ACCEPTED: preload("res://assets/sounds/vb_accepted_8bit-pickup15.wav"),
	#VB_DISMISSED: preload("res://assets/sounds/vb_not_accepted_8bit-blip11.wav"),
	VB_DISMISSED: preload("res://assets/sounds/vb_no.wav"),
	VB_COUNT: preload("res://assets/sounds/vb_not_accepted_8bit-blip11.wav"),
	LEVEL_COMPLETE: preload("res://assets/sounds/level_success.mp3"),
	GAME_OVER: preload("res://assets/sounds/game_over.mp3"),
	LOSE_POINTS: preload("res://assets/sounds/lose_points.wav")
}

func play_clip(player:AudioStreamPlayer2D, clip_key:String):
	if not SOUNDS.has(clip_key):
		return
	player.stream = SOUNDS[clip_key]
	player.play()
