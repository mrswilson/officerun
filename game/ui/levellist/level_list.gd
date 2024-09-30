extends MainscreenOverlay


var _level_scenes:Array = []
@onready var close_button = $Mainscreen/VB/CloseButton
@onready var list = $Mainscreen/VB/ScrollContainer/list

var LevelButton = preload("res://game/ui/levellist/level_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_levels()


func load_levels():
	'''
	# for ln in range(1, TOTAL_LEVELS + 1):
	var ln:int = 1
	var level_found:bool = true
	while level_found:
		var filename = "res://game/levels/level_%s.tscn" % ln
		if FileAccess.file_exists(filename):
			_level_scenes.append(load(filename))
			ln += 1
		else:
			level_found = false
	'''
	var levellist = GameManager.get_levellist()
	var levelnumber = 1
	for entry in levellist:
		var button:LevelButton = LevelButton.instantiate()
		list.add_child(button)
		button.set_level(levelnumber)
		levelnumber += 1
	#print(_level_scenes)


func _on_close_button_pressed():
	hide()


func _on_visibility_changed():
	if visible and close_button:
		list.get_child(0).grab_focus()
	
