extends Control
class_name HUD

# === Overlay ===
# @onready var game_over_screen = $GameOverScreen
@onready var overlay = $Overlay
@onready var vb_level_complete = $Overlay/VBoxContainer/VBoxContainer/VB_Level_complete
@onready var label_press_key = $Overlay/VBoxContainer/Label_press_key

# === HUD === 
@onready var score_label = $VBoxContainer/top/MC/VB/HB/VBoxContainer/ScoreLabel
@onready var highscore_label = $VBoxContainer/top/MC/VB/HB/VBoxContainer/highscoreLabel

@onready var timer_label = $VBoxContainer/top/MC/VB/HB/TimerLabel

@onready var escalation_counter = $VBoxContainer/top/MC/VB/HB/VBoxContainer2/EscalationCounter
@onready var vb_counter = $VBoxContainer/top/MC/VB/HB/VBoxContainer2/VBCounter
@onready var alarm_counter_list = $VBoxContainer/top/MC/VB/HBoxContainer/AlarmCounterList

var MyAlarmCounter = preload("res://game/hud/alarm_counter.tscn")
@onready var intranet_counter = $VBoxContainer/top/MC/VB/HBoxContainer/IntranetCounter


# Infobar
@onready var info_label_bar = $VBoxContainer/InfoLabelBar
@onready var info_label = $VBoxContainer/InfoLabelBar/InfoLabel

@onready var hud_timer = $hudTimer

@export var hotspots:Node2D
var alarm_hotspots:Dictionary = {}

const ESC_WHITE:Texture = preload("res://assets/ui/escalation_singles_33.png")
const ESC_RED:Texture = preload("res://assets/ui/escalation_singles_32.png")

#var _escalations: Array
var is_hud_interactable = false
var has_intranet = false 


func _ready():
	SignalManager.on_escalation.connect(_on_escalation)
	SignalManager.pickup_bug.connect(_on_pickup_bug)
	SignalManager.on_score_updated.connect(_on_score_updated)
	SignalManager.level_completed.connect(_on_level_completed)
	SignalManager.vb_entry.connect(_on_vb_entry)
	SignalManager.meeting_started.connect(_on_meeting_started)
	
	SignalManager.read_intranet_start.connect(hide_lists)
	SignalManager.read_intranet_stop.connect(show_lists)
	
	_setup_alarm_counters()
	var hs = LeaderboardManager.get_highscore()
	highscore_label.text = "TOP: %04d" % hs
	_on_score_updated()


func _process(_delta):
	if is_hud_interactable:
		if vb_level_complete.visible:
			# if Input.is_action_just_pressed("interact"):
			if Input.is_anything_pressed():
				GameManager.load_next_level_scene()


func _setup_alarm_counters():
	#var alarm_hotspots:Array = []
	for hs:Hotspot in hotspots.get_children():
		if hs.hasAlarm and hs.damage_points > 0:
			#print("adding %s" % hs.hotspot_name)
			alarm_hotspots[hs.hotspot_name] = hs
			add_alarm(hs)


func add_alarm(hotspot:Hotspot):
	var new_alarm_counter:AlarmCounter = MyAlarmCounter.instantiate()
	alarm_counter_list.add_child(new_alarm_counter)
	new_alarm_counter.set_hotspot(hotspot)


func set_escalations(esc:int):
	escalation_counter.set_no_of_active_items(esc)


func show_hud():
	overlay.visible = true
	hud_timer.set_paused(false)
	hud_timer.start()


func hide_lists():
	alarm_counter_list.hide()
	intranet_counter.hide()
	

func show_lists():
	alarm_counter_list.show()
	if has_intranet:
		intranet_counter.show()


func show_intranetcounter(max_count:int):
	has_intranet = true
	intranet_counter.set_no_of_entries(max_count)
	intranet_counter.show()

	
func setTimerText(text:String):
	timer_label.text = text


func show_message(message):
	info_label.text = message
	info_label_bar.visible = true


func hide_message():
	info_label_bar.visible = false
	info_label.text = ""


func _on_score_updated():
	#var score_text = "SCORE: %04d" % ScoreManager.get_score()
	var score_text = "SCORE: %04d" % LeaderboardManager.get_score()
	score_label.text = score_text


func _on_pickup_bug(_points:int):
	pass


func _on_vb_entry():
	vb_counter.increase()


func _on_meeting_started():
	vb_counter.reset()


func _on_level_completed():
	vb_level_complete.visible = true
	# vb_game_over.visible = false
	show_hud()


func _on_escalation():
	escalation_counter.increase()


func _on_vb():
	vb_counter.increase()


func _on_hud_timer_timeout():
	label_press_key.set_visible(true)
	is_hud_interactable = true
