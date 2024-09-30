extends PanelContainer
class_name IntranetCounter

@onready var label = $HB/Label
var no_of_entries = 0
var read = 0
var color_done = "65af4f"

func _ready():
	hide()
	SignalManager.read_intranet_stop.connect(_entry_read)


func update_label():
	label.text = "%s / %s" % [read, no_of_entries]
	

func set_no_of_entries(n:int):
	no_of_entries = n
	update_label()
	
	
func set_read_entries(n:int):
	read = n 
	update_label()


func _entry_read():
	read += 1
	update_label()
	if read >= no_of_entries:
		print("all entries read")
		self.modulate = Color(color_done)
		SignalManager.gain_points.emit(250)
