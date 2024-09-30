extends ItemCounter

const ANFRAGEN_1 = preload("res://assets/ui/anfragen1.png") # gelb
const ANFRAGEN_2 = preload("res://assets/ui/anfragen2.png") # gruen
const ANFRAGEN_3 = preload("res://assets/ui/anfragen3.png") # rot
var textures:Array = [ANFRAGEN_2, ANFRAGEN_3]
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


@onready var score_delay_timer = $ScoreDelayTimer
@export var points = 30
var all_points = 0


func _ready():
	super._ready()
	SignalManager.meeting_started.connect(_meeting_started)


func _meeting_started():
	pass
	#randomizer()

'''
func randomizer():
	var result = 0
	var success = 0
	for item in items:
		result = randi_range(0, 1)
		var tex = textures[result]
		
		await _pop_up(item)
		
		var duration = 6
		await _turn_wheel(item, duration)
		
		#var tween = get_tree().create_tween()
		#tween.tween_property(item, "texture", tex, 0.1)
		item.texture = tex
		await _pop_down(item)
		
		if result == 0:
			success += 1
			SoundManager.play_clip(audio_stream_player_2d, SoundManager.VB_ACCEPTED)
		else:
			SoundManager.play_clip(audio_stream_player_2d, SoundManager.VB_DISMISSED)
		await get_tree().create_timer(0.7).timeout
		
	all_points = success * points
	# print("%s Treffer = %s Punkte" % [success, points])
	score_delay_timer.start()
'''

'''
func _pop_up(item): # 0.2 sec
	var tween:Tween = get_tree().create_tween()
	var trans_type = Tween.TRANS_ELASTIC
	var ease_type = Tween.EASE_IN

	var delta_value = Vector2(0.9, 0.9)
	var duration = 0.05
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)

	delta_value = Vector2(1.3, 1.3)
	duration = 0.2
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
	

func _pop_down(item): # 0.3 sec 
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


func _turn_wheel(item, duration):
	var steps:float = 0.05
	for i in range(duration):
		var tex = textures.pick_random()
		item.texture = tex
		await get_tree().create_timer(steps).timeout


func _on_score_delay_timer_timeout():
	LeaderboardManager.update_score(all_points)
	score_delay_timer.stop()
	super.reset()

