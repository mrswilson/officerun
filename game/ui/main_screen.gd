extends CanvasLayer

@onready var highscore_label = $Mainscreen/VB/highscoreLabel

@onready var mainscreen = $Mainscreen

# overlay screens
@onready var level_list = $LevelList
@onready var leaderboard = $Leaderboard
@onready var sw_leaderboard = $SW_Leaderboard

@onready var credits = $credits
@onready var options = $options

# BUttons
@onready var playbutton = $Mainscreen/VB/options/playbutton
@onready var levellistbutton = $Mainscreen/VB/options/levellistbutton
@onready var highscorebutton = $Mainscreen/VB/options/highscorebutton
@onready var creditsbutton = $Mainscreen/VB/options/creditsbutton
@onready var optionsbutton = $Mainscreen/VB/options/optionsbutton

var is_input_ok = false

func _ready():
	Engine.time_scale = 1
	get_tree().paused = false
	var hs = LeaderboardManager.get_highscore()
	if hs > 0:
		highscore_label.text = "highscore: %04d" % hs
		highscore_label.visible = true
	else:
		highscore_label.visible = false
	playbutton.grab_focus()
	leaderboard.hide()
	credits.hide()
	options.hide()
	level_list.hide()


func _process(_delta):
	# if Input.is_action_just_pressed("interact"):
	#	GameManager.load_next_level_scene()
	if is_input_ok:
		if Input.is_action_just_released("quit"):
			'''
			if leaderboard.visible:
				show_main_menu()
				highscorebutton.grab_focus()
			elif creditscene.visible:
				show_main_menu()
				creditsbutton.grab_focus()
			elif options_scene.visible:
				show_main_menu()
				optionsbutton.grab_focus()
			elif mainscreen.visible:
			'''
			if mainscreen.visible:
				get_tree().quit()



func show_main_menu():
	mainscreen.visible = true
	leaderboard.show()
	level_list.show()
	credits.show()
	options.show()
	playbutton.grab_focus()
	

func show_leaderboard():
	#mainscreen.visible = false
	if LeaderboardManager.is_online:
		sw_leaderboard.show()
	else:		
		leaderboard.show()


func show_levellist():
	#mainscreen.visible = false
	level_list.show()


func show_credits():
	#mainscreen.visible = false
	credits.show()


func show_options():
	#mainscreen.visible = false
	options.show()
	options.lang_button.grab_focus()


func _on_playbutton_pressed():
	GameManager.start_game()
	# GameManager.load_next_level_scene()

func _on_highscorebutton_pressed():
	show_leaderboard()

func _on_training_button_pressed():
	show_levellist()

func _on_creditsbutton_pressed():
	show_credits()

func _on_optionsbutton_pressed():
	show_options()

func _on_timer_timeout():
	is_input_ok = true



func _on_leaderboard_hidden():
	highscorebutton.grab_focus()


func _on_credits_hidden():
	creditsbutton.grab_focus()


func _on_options_hidden():
	optionsbutton.grab_focus()


func _on_level_list_hidden():
	levellistbutton.grab_focus()
