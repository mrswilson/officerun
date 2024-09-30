extends Control

@onready var no_button = $PanelContainer/VBoxContainer/HBoxContainer/NoButton

signal resume_game
signal quit_game


func _on_yes_button_pressed():
	quit_game.emit()


func _on_no_button_pressed():
	resume_game.emit()


func _on_visibility_changed():
	if visible:
		no_button.grab_focus()
