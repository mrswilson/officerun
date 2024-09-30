extends Control

@onready var label = $HBoxContainer/Label
@onready var progress_bar = $HBoxContainer/ProgressBar
@onready var icon = $HBoxContainer/icon
@onready var animation_player = $AnimationPlayer


@export var max_value:int = 5
@export var alarm_value:int = 2
@export var labeltext:String = "Kaffee"
@export var icon_image:Texture2D
@export var alarm_image:Texture2D

@export var count_down:bool = false
@export var timer:Timer

func _ready():
	label.text = labeltext
	icon.texture = icon_image
	progress_bar.max_value = max_value
	progress_bar.value = 0
	if timer:
		max_value = timer.wait_time
		


func _on_progress_bar_value_changed(value):
	#if value >= max_value:
	if count_down:
		if value <= alarm_value:
			icon.texture = alarm_image
			animation_player.play("blink")
	else:
		if value >= alarm_value:
			icon.texture = alarm_image
			animation_player.play("blink")


func _on_reset_progress():
	icon.texture = icon_image
	animation_player.play("RESET")
	

func advance():
	progress_bar.value += 1


func reduce():
	progress_bar.value -= 1
	
