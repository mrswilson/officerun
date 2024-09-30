extends Control
class_name LetterLabel
@onready var letter_label = $letter_label


var LETTERS:Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "_", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*"]
var cur_index = 0
var is_active:bool = false


func _ready():
	pass # Replace with function body.

func _process(_delta):
	#if is_active:
	if has_focus():
		letter_label.modulate = "f3b615"
		if Input.is_action_just_pressed("ui_up"):
			letter_up()
		elif Input.is_action_just_pressed("ui_down"):
			letter_down()

	else:
		letter_label.modulate = "ffffff"		


func get_letter():
	return letter_label.text


func letter_up():
	cur_index += 1
	if cur_index >= LETTERS.size():
		cur_index = 0
	update_letter()

	
func letter_down():
	if cur_index == 0:
		cur_index = LETTERS.size()-1
	else:
		cur_index -= 1 
	update_letter()

func set_letter(letter:String):
	letter_label.text = letter
	cur_index = LETTERS.find(letter)

func update_letter():
	letter_label.text = LETTERS[cur_index]

