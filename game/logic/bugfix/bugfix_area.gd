extends Area2D

var is_alarm:bool = false
var show_alarm_marker:bool = true
var minimap_icon = "bas"


func _on_area_entered(_area):
	if is_alarm:
		SignalManager.meeting_started.emit()


func _on_body_exited(_body):
	if is_alarm:
		is_alarm = false
		SignalManager.meeting_over.emit()
