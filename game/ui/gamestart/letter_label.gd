extends Control
@onready var letter_label = $letter_label


var LETTERS:Array = ["A", "B", "C", "D"]
var cur_index = 0
var is_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if is_active:
		letter_label.modulate = "f3b615"
		if Input.is_action_just_pressed("ui_up"):
			letter_up()
		elif Input.is_action_just_pressed("ui_down"):
			letter_down()
	else:
		letter_label.modulate = "ffffff"		



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

func update_letter():
	letter_label.text = LETTERS[cur_index]
	
