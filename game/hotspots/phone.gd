extends Hotspot


func _ready():
	super._ready()


func _interact():
	if is_alarm:
		SignalManager.vb_entry.emit()
	super._interact()
