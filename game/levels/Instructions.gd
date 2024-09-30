extends MarginContainer


@onready var animation_player = $AnimationPlayer
@onready var press_any_key = $Panel/VBoxContainer/press_any_key



func _process(_delta):
	if visible:
		if press_any_key.visible:
			if Input.is_anything_pressed():
				visible = false
				get_tree().paused = false
				SignalManager.level_start.emit()


func _on_instruction_timer_timeout():
	press_any_key.visible = true
