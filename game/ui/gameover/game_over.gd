extends Control

@onready var game_over = $MarginContainer/VBoxContainer/gameOver
@onready var enter_name = $MarginContainer/VBoxContainer/enterName
@onready var letter_1 = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_1
@onready var letter_2 = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_2
@onready var letter_3 = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_3
@onready var animation_player = $AnimationPlayer
@onready var score_label = $MarginContainer/VBoxContainer/gameOver/VBoxContainer/HBoxContainer/scoreLabel

@onready var playagain_label = $MarginContainer/VBoxContainer/playagainLabel
@onready var button_panel = $MarginContainer/VBoxContainer/buttonPanel
@onready var yes_button = $MarginContainer/VBoxContainer/buttonPanel/yesButton
@onready var no_button = $MarginContainer/VBoxContainer/buttonPanel/noButton

var new_hs:bool = false
var is_input_ok:bool = false
@onready var LETTERS:Array = [letter_1, letter_2, letter_3]
var cur_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# enter_name.visible = new_hs
	LETTERS[cur_index].is_active = true
	score_label.text = str(LeaderboardManager.get_score())
	yes_button.grab_focus()
	#playagain_label.visible = !GameManager._is_training
	#button_panel.visible = !GameManager._is_training

func reset_scores():
	LeaderboardManager.reset_score()


func letter_back():
	LETTERS[cur_index].is_active = false
	if cur_index <= 0:
		cur_index = LETTERS.size()-1
	else:
		cur_index -= 1
	LETTERS[cur_index].is_active = true


func letter_next():
	LETTERS[cur_index].is_active = false
	if cur_index >= LETTERS.size()-1:
		cur_index = 0
	else:
		cur_index += 1
	LETTERS[cur_index].is_active = true


func _on_timer_timeout():
	is_input_ok = true



func _on_yes_button_pressed():
	reset_scores()
	if GameManager._is_training:
		GameManager.restart_level()
	else:
		GameManager.load_next_level_scene()


func _on_no_button_pressed():
	reset_scores()
	GameManager.load_main_scene()
