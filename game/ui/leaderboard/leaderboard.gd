extends MainscreenOverlay

@onready var list = $MarginContainer/HBoxContainer2/MarginContainer/list
@onready var close_button = $MarginContainer/HBoxContainer2/CloseButton


var LBE = preload("res://game/ui/leaderboard/leaderboard_entry.tscn")

var scores = []

const POINTS = "POINTS"
const NAME = "NAME"
const LEVEL = "LEVEL"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("setup leaderboard")
	setup_table()
	SignalManager.sw_loaded.connect(_load_table)
	
	
func _load_table():
	setup_table()


func setup_table():
	print("setup_table")
	clear_list()
	
	var table = await LeaderboardManager.get_score_table()
	var rank = 1
	for entry in table:
		#print("adding entry: %s" % entry)
		var lbe = LBE.instantiate()
		var playername = entry[LeaderboardManager.PLAYERNAME_KEY]
		var score = entry[LeaderboardManager.SCORE_KEY]
		var level = entry[LeaderboardManager.LEVEL_KEY]
		list.add_child(lbe)
		lbe.init(playername, score, level, rank)
		rank += 1

func clear_list():
	var entries = list.get_children()
	var is_first:bool = true
	for e in entries:
		if is_first: 
			is_first = false
		else:
			list.remove_child(e)


func get_scores():
	scores.sort_custom(sort_ascending)


func get_best():
	var best:Array = []
	scores.sort_custom(sort_ascending)
	for i in range(0, 10):
		best.append(scores[i])


func sort_ascending(a, b):
	if a[POINTS] < b[POINTS]:
		return true
	return false


func _on_close_button_pressed():
	hide()


func _on_visibility_changed():
	if visible:
		#await setup_table()
		if close_button:
			close_button.grab_focus()
