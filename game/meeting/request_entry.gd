extends PanelContainer
class_name RequestEntry

const COLOR_RED = "ff7066"
const COLOR_YELLOW = "eff09e"
const COLOR_GREEN = "65af4f"
@onready var label = $HBoxContainer/Label


func set_color(colorkey):
	self.modulate = Color(colorkey)

func set_title(title:String):
	label.text = title
