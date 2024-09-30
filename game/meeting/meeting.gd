extends Control
class_name MeetingPanel

@onready var audio_stream_player = $AudioStreamPlayer
@onready var score_delay_timer:Timer = $scoreDelayTimer
@onready var request_timer:Timer = $requestTimer

@onready var footer = $Meeting/VB/MarginContainer/VBoxContainer/footer
@onready var list = $Meeting/VB/MarginContainer/VBoxContainer/List

@onready var punkte_counter_label = $Meeting/VB/MarginContainer/VBoxContainer/footer/PunkteCounterLabel
@onready var angenommen_counter_label = $Meeting/VB/ColorRect/header/angenommenCounterLabel
@onready var abgelehnt_counter_label = $Meeting/VB/ColorRect/header/abgelehntCounterLabel


const REQUEST_ENTRY = preload("res://game/meeting/request_entry.tscn")
var entries:Array[RequestEntry] = []

const titles:Array = ["update", "autogpt", "Firmenevent", "Baumumfang messen", "Quellenmonitor", "Server down", "Produktionsvorbereitung","Erste Notiz", "entg. Telefonat", "Verbesserungsvorschlag", "Bugreport", "Neues Feature", "Passwort vergessen", "2nd Level Anfrage", "Kundenwunsch", "Newsetter", "Updatelog"]

@export var points:int = 30
var all_points:int = 0
var no_of_requests:int = 5

signal meeting_over

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.meeting_started.connect(_meeting_started)
	punkte_counter_label.text = "??"
	abgelehnt_counter_label.text = "0"
	angenommen_counter_label.text = "0"
	footer.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _meeting_started():
	punkte_counter_label.text = "??"
	abgelehnt_counter_label.text = "0"
	angenommen_counter_label.text = "0"
	footer.hide()
	await show_requests()
	start_randomizer()


func show_requests():
	for i in range(0, no_of_requests):
		request_timer.start()
		await request_timer.timeout
		add_request()
		SoundManager.play_clip(audio_stream_player, SoundManager.VB_COUNT)
	request_timer.start()
	await request_timer.timeout
	footer.show()


func add_request():
	var request_entry = REQUEST_ENTRY.instantiate()
	list.add_child(request_entry)
	request_entry.set_title(titles.pick_random())
	entries.append(request_entry)


func start_randomizer():
	var result = 0
	var success = 0
	for entry in entries:
		result = randi_range(0, 1)
		var duration = 6
		await _turn_wheel(entry, duration)
		var denied = 0
		if result == 0:
			success += 1
			entry.set_color(RequestEntry.COLOR_GREEN)
			angenommen_counter_label.text = str(success)
			punkte_counter_label.text = str(success * points)
			SoundManager.play_clip(audio_stream_player, SoundManager.VB_ACCEPTED)
		else:
			denied += 1
			entry.set_color(RequestEntry.COLOR_RED)
			abgelehnt_counter_label.text = str(denied)
			SoundManager.play_clip(audio_stream_player, SoundManager.VB_DISMISSED)
		all_points = success * points
		punkte_counter_label.text = str("%s x %s = %s" % [success, points, all_points])
		await get_tree().create_timer(0.7).timeout
		
	all_points = success * points
	score_delay_timer.start()
	LeaderboardManager.update_score(all_points)
	
	await get_tree().create_timer(2).timeout
	clean_list()
	meeting_over.emit()


func clean_list():
	for e in entries:
		e.queue_free()
	entries = []
	

func _pop_up(item): # 0.2 sec
	pass
	'''
	var tween:Tween = get_tree().create_tween()
	var trans_type = Tween.TRANS_ELASTIC
	var ease_type = Tween.EASE_IN

	var delta_value = Vector2(0.9, 0.9)
	var duration = 0.05
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)

	delta_value = Vector2(1.3, 1.3)
	duration = 0.2
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
	'''
	

func _pop_down(item): # 0.3 sec 
	pass
	'''
	var tween:Tween = get_tree().create_tween()
	var trans_type = Tween.TRANS_ELASTIC
	var ease_type = Tween.EASE_IN
	var delta_value = Vector2(0.8, 0.8)
	var duration = 0.1
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
		
	delta_value = Vector2(1, 1)
	duration = 0.2
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
	'''


func _turn_wheel(entry:RequestEntry, duration):
	var steps:float = 0.1
	var colors = [RequestEntry.COLOR_YELLOW, RequestEntry.COLOR_GREEN, RequestEntry.COLOR_RED]
	var color = colors.pick_random()
	for i in range(duration):
		#var tex = textures.pick_random()
		#item.texture = tex
		color = colors.pick_random()
		entry.set_color(color)
		await get_tree().create_timer(steps).timeout
