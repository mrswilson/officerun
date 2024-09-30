extends Control
class_name MainscreenOverlay


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		hide()
