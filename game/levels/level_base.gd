extends Node2D
class_name Level

# UI Setup
@onready var player_cam = $PlayerCam
@onready var player:Player = $Room/Player
@onready var hud:HUD = $"UI Overlay/HUD"
#@onready var meeting_scene = $"UI Overlay/MeetingScene"
@onready var level_timer = $LevelTimer

@onready var instructions = $"UI Overlay/Instructions"
@onready var yes_no_dialog = $"UI Overlay/YesNoDialog"
@onready var meeting_panel = $"UI Overlay/MeetingPanel"

@onready var room = $Room
@onready var waypoints = $Room/Bugs/waypoints
@onready var hotspots:Node2D = $Room/Hotspots
@onready var meeting = $Room/Meeting
@onready var intranet = $Room/Intranet

@onready var bas_blinker = $Room/Meeting/bas_blinker
@onready var bugfix_area = $Room/Meeting/BugfixArea

@onready var bg_music_player = $BGMusicPlayer
@onready var minimap = $"UI Overlay/Minimap"

# Options
@export var level_number:int = 1
@export_range(10, 300) var duration:int = 60
var max_escalations = 5
@export var has_vbs:bool = true


# HUD Counters
var _no_of_bugs_collected:int = 0
var _no_of_vbs:int = 0
var _max_vbs = 5
var no_of_intranetbeitraege = 0
var no_of_intranetbeitraege_read = 0
#var hotspotlist:Array

# Sound
@onready var sound_player = $SoundPlayer

var start:bool = false


func _ready():
	SignalManager.bug_escaped.connect(_bug_escaped)
	SignalManager.on_game_over.connect(_game_over)
	SignalManager.level_start.connect(start_level)
	SignalManager.barrel_activated.connect(_barrel_activated)

	SignalManager.vb_entry.connect(_vb_entry)
	SignalManager.meeting_started.connect(_meeting_started)

	#SignalManager.klo_entered.connect(_klo_entered)
	#SignalManager.klo_flushed.connect(_klo_flushed)

	SignalManager.read_intranet_start.connect(_hide_minimap)
	SignalManager.read_intranet_stop.connect(_show_minimap)
	
	SignalManager.hide_messages.connect(hide_message)
	SignalManager.loose_points.connect(_lose_points)
	
	no_of_intranetbeitraege = intranet.get_children().size()
	_no_of_bugs_collected = 0
	
	room.bake_navigation_polygon(true)
	_setup_timer()
	_setup_rooms()
	_setup_hud()
	
	minimap.visible = false
	yes_no_dialog.hide()
	player_cam.position = player.position
	get_tree().paused = true
	#hud.set_escalations(ScoreManager.bugs_escaped)


func _process(_delta):
	player_cam.position = player.position
	_update_timer()
	if Input.is_action_just_pressed("quit"):
		show_quit()


func _setup_hud():
	hud.visible = false
	hud.vb_counter.visible = has_vbs
	hud.set_escalations(LeaderboardManager.bugs_escaped)
	if no_of_intranetbeitraege > 0:
		hud.show_intranetcounter(no_of_intranetbeitraege)


func _setup_rooms():
	meeting.visible = has_vbs
	instructions.show()
	meeting_panel.hide()


func _setup_timer():
	level_timer.wait_time = duration

	var digits = []
	var digit_format = "%02d"
	var minutes = digit_format % [duration / 60]
	var seconds = digit_format % fmod(duration, 60)
	digits.append(minutes)
	digits.append(seconds)
	hud.setTimerText(digits[0] + ":" + digits[1])


func _update_timer():
	#print("update timer")
	var digits = []
	var digit_format = "%02d"
	var time_left = level_timer.time_left
	
	var minutes = digit_format % [time_left / 60]
	var seconds = digit_format % fmod(time_left, 60)
	
	digits.append(minutes)
	digits.append(seconds)
	hud.setTimerText(digits[0] + ":" + digits[1])


func start_level():
	instructions.hide()
	bg_music_player.play()
	start = true
	level_timer.start(duration)
	_update_timer()
	get_tree().paused = false
	duration += 1
	minimap.visible = minimap.show_map
	hud.visible = true
	LeaderboardManager.set_level(level_number)


func show_message(message):
	hud.show_message(message)


func pause_game(pauseit:bool):
	get_tree().paused = pauseit
	#level_timer.paused = pauseit


func _hide_minimap():
	minimap.hide()


func _show_minimap():
	minimap.show()


func show_quit():
	yes_no_dialog.show()
	pause_game(true)


func resume_game():
	player.timer_bar.hide()
	pause_game(false)


func hide_message():
	hud.hide_message()


func _barrel_activated():
	show_message(tr("MESSAGE_BARREL"))


func _vb_entry():
	_no_of_vbs += 1
	if _no_of_vbs >= _max_vbs:
		bas_blinker.play("bas_blink")
		bugfix_area.is_alarm = true
		show_message("Besprechung! Jetzt!")


func _lose_points(_points):
	SoundManager.play_clip(sound_player, SoundManager.LOSE_POINTS)


func _meeting_started():
	bas_blinker.play("RESET")
	_no_of_vbs = 0
	player.pause_player_action(6, Player.IDLE)
	hide_message()
	meeting_panel.show()
	pause_game(true)


func _bug_escaped():
	SignalManager.on_escalation.emit()
	if LeaderboardManager.bugs_escaped >= max_escalations:
		SignalManager.on_game_over.emit()


func _game_over():
	SoundManager.play_clip(sound_player, SoundManager.GAME_OVER)
	GameManager.show_game_over()


func _on_level_timer_timeout():
	SignalManager.level_completed.emit()
	SoundManager.play_clip(sound_player, SoundManager.LEVEL_COMPLETE)
	set_process(false)
	set_physics_process(false)
	
	_update_timer()


func _on_player_cam_tree_exited():
	# print("tree exited	e")
	pass


func _on_yes_no_dialog_quit_game():
	get_tree().paused = false # der Tree muss weiterlaufen, sonst reagiert gar nichts mehr
	SignalManager.on_game_over.emit()


func _on_yes_no_dialog_resume_game():
	yes_no_dialog.hide()
	resume_game()


func _on_meeting_panel_meeting_over():
	meeting_panel.hide()
	resume_game()

