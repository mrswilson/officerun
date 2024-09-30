extends Polygon2D
class_name ActionArea

@onready var area = $area
@onready var blink_animation_player = $blinkAnimationPlayer

@export var trigger:Hotspot
@export var show_alarm_marker:bool = true
@export var minimap_icon = "bas"
#@export var actionTrigger:Hotspot

signal action_area_entered
signal action_area_exited

var is_alarm:bool = false


func _ready():
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = polygon
	area.add_child(collision_polygon)
	#actionTrigger.hotspot_alarm_started.connect(activate)


func activate():
	is_alarm = true
	blink_animation_player.play("blink")



func _on_area_body_entered(body):
	if is_alarm:
		#SignalManager.meeting_started.emit()
		action_area_entered.emit()
	if trigger:
		trigger.reset()


func _on_area_body_exited(body):
	if is_alarm:
		is_alarm = false
		blink_animation_player.stop()
		action_area_exited.emit()


func _on_area_timer_timeout():
	pass # Replace with function body.
