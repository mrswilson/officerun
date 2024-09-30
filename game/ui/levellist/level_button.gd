extends Button
class_name LevelButton

var ln:int = 0

func set_level(levelnumber:int):
	ln = levelnumber
	var levelname = tr("LEVEL_%s_TITLE" % levelnumber)
	text = "Level %s:  %s" % [levelnumber, levelname]


func _on_pressed():
	GameManager.load_level_scene(ln)
