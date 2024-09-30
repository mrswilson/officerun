extends Area2D

var is_alarm:bool = false
var show_alarm_marker:bool = true
var minimap_icon = "bas"
@onready var klo_blinker = $"../klo_blinker"

func _on_area_entered(_area):
	if is_alarm:
		klo_blinker.stop()
		#is_alarm = false
		SignalManager.klo_entered.emit()


func _on_body_exited(_body):
	if is_alarm:
		is_alarm = false
		SignalManager.klo_flushed.emit()


func _on_klo_timer_timeout():
	klo_blinker.play("klo_blinker")
	is_alarm = true
