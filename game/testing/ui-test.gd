extends Control

@onready var button = $CenterContainer/VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	pass
