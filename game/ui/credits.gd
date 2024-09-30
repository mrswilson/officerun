# extends Control
extends MainscreenOverlay
@onready var close_button = $MC/VB/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_close_button_pressed():
	hide()



func _on_visibility_changed():
	if visible:
		close_button.grab_focus()

