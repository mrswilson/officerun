extends Hotspot
class_name CoffeeMaker

@export var actionArea:ActionArea
@export var player:Player


'''
Kaffee interact 
  => timer starten
  => progressbar anzeigen

timer #1 abgelaufen
  => Klo blinkt

timer #2 abgelaufen
  => game over
'''


func _interact():
	timer.wait_time = randi_range(timeout_after.x, timeout_after.y)
	
	timer.start()


func _on_timer_timeout():
	actionArea.activate()
	super._on_timer_timeout()


func _on_pointer_countdown():
	SignalManager.on_escalation.emit()


