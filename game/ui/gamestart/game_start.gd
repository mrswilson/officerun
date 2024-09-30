extends Control

@onready var enter_name = $MarginContainer/VBoxContainer/enterName
@onready var letter_1:LetterLabel = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_1
@onready var letter_2:LetterLabel = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_2
@onready var letter_3:LetterLabel = $MarginContainer/VBoxContainer/enterName/VBoxContainer/letters/letter_3

@onready var back_button = $MarginContainer/VBoxContainer/HBoxContainer/backButton
@onready var play_button = $MarginContainer/VBoxContainer/HBoxContainer/PlayButton

const PLAYER_FILE = "user://player.dat"

#var new_hs:bool = false
#var is_input_ok:bool = false
@onready var LETTERS:Array = [letter_1, letter_2, letter_3]
var cur_index = 0


func _ready():
	LETTERS[cur_index].is_active = true
	init_letters()
	letter_1.grab_focus()


func init_letters():
	var pn:String = load_file()
	if pn and pn.length() == 3:
		letter_1.set_letter(pn[0])
		letter_2.set_letter(pn[1])
		letter_3.set_letter(pn[2])


func save_file(content):
	var file = FileAccess.open(PLAYER_FILE, FileAccess.WRITE)
	file.store_string(content)


func load_file():
	if not FileAccess.file_exists(PLAYER_FILE):
		print("File not found")
		return ""
	else:
		var file = FileAccess.open(PLAYER_FILE, FileAccess.READ)
		var content = file.get_as_text()
		return content


func play():
	var l1 = letter_1.get_letter()
	var l2 = letter_2.get_letter()
	var l3 = letter_3.get_letter()
	var playername = l1+l2+l3
	save_file(playername)
	LeaderboardManager.reset_score()
	LeaderboardManager.set_playername(playername)
	GameManager.load_next_level_scene()

func back():
	GameManager.load_main_scene()
		

func _on_play_button_pressed():
	play()


func _on_back_button_pressed():
	back()
