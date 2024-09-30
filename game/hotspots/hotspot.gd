extends StaticBody2D
class_name Hotspot

@onready var animation_player = $AnimationPlayer
@onready var interaction_area:InteractionArea = $InteractionArea
@onready var timer = $Timer
@onready var damage_countdown = $damageCountdown
@onready var sprite_collision = $spriteCollision

@onready var icon = $icon

@export var hotspot_name:String = "not_set"
@export var points:int = 10

@export var timeout_after:Vector2i = Vector2i(10, 20)

# alarm
@export var hasAlarm:bool = true
@export var alarm_icon:Texture2D
@export var alarm_message:String

# Zeit in Sekunden, nach der Punkte abgezogen werden
@export var damage_after:int = 10
@export var damage_points:int = 2
@export var alarm_sound:AudioStream
@export var alarm_sound_interval:float = 2.5

@onready var alarm_interval_timer = $Alarm/alarmIntervalTimer
@onready var alarm_sound_player = $Alarm/alarmSoundPlayer
@export var pause_during_meeting:bool = true

@export var show_alarm_marker:bool = true
@export var minimap_icon = "alarm"

signal hotspot_alarm_started(hotspot_name)
signal hotspot_damage(hotspot_name, damage_points:int)
signal hotspot_alarm_off(hotspot_name)


var is_alarm:bool = false
var is_meeting = false


func _ready():
	interaction_area.interact = Callable(self, "_interact")
	if hasAlarm:
		interaction_area.set_active(false)
	else:
		interaction_area.set_active(true)		
	SignalManager.meeting_started.connect(_on_meeting_started)
	SignalManager.meeting_over.connect(_on_meeting_over)
	SignalManager.level_completed.connect(_level_complete)
	_setup_alarm()


func _setup_alarm():
	if hasAlarm:
		timer.start(randi_range(timeout_after.x, timeout_after.y))
		alarm_sound_player.stream = alarm_sound
		alarm_interval_timer.wait_time = alarm_sound_interval
	if not show_alarm_marker:
		remove_from_group("minimap_objects")


func _interact():
	timer.wait_time = randi_range(timeout_after.x, timeout_after.y)
	timer.start()
	if is_alarm:
		animation_player.play("RESET")
		#idle_player.play("idle")
		is_alarm = false
		interaction_area.set_active(false)
		if points != 0:
			SignalManager.gain_points.emit(points)
		hotspot_alarm_off.emit(hotspot_name)
		alarm_interval_timer.stop()
		damage_countdown.stop()


func _level_complete():
	timer.stop()
	damage_countdown.stop()
	animation_player.stop()


func _on_timer_timeout():
	if not is_alarm:
		animation_player.play("alarm")
		is_alarm = true
		interaction_area.set_active(true)
		damage_countdown.start(damage_after)
		alarm_interval_timer.start() # alarm-sound starten
		alarm_sound_player.play()
		hotspot_alarm_started.emit(hotspot_name)
		# add_counter_to_hud


func _on_pointer_countdown():
	if is_alarm:
		SignalManager.loose_points.emit(damage_points)
		# count down icon in hud
		#print("+++ hotspot %s emitting damage" % hotspot_name)
		hotspot_damage.emit(hotspot_name, damage_points)


func _on_alarm_interval_timer_timeout():
	alarm_sound_player.play()
	alarm_interval_timer.start(0)

func reset():
	print("resetting %s" % hotspot_name)
	if hasAlarm:
		timer.paused = false
		timer.start(0)
		alarm_interval_timer.stop()
	

func _on_meeting_started():
	if pause_during_meeting and hasAlarm:
		animation_player.play("RESET")
		is_alarm = false
		interaction_area.set_active(false)
		hotspot_alarm_off.emit(hotspot_name)
		timer.wait_time = randi_range(timeout_after.x, timeout_after.y)
		timer.paused = true


func _on_meeting_over():
	if pause_during_meeting and hasAlarm:
		timer.paused = false
		timer.start(0)
		alarm_interval_timer.stop()
