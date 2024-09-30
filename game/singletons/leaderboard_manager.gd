extends Node


const YOUR_SILENTWOLF_API_KEY = "Rf873ugkSQav0wKLhVPXqAoTm4vL7hp3PRE18wEf"
const YOUR_SILENTWOLF_GAME_ID = "officerun"
const is_online = true

const HIGHSCORE_FILE = "user://leaderboard.dat"

const PLAYERNAME_KEY: String = "playername"
const SCORE_KEY: String = "score"
const LEVEL_KEY: String = "level"

var leaderboard_table = []
const max_entries:int = 10


var cur_playername:String = "XXX"
var _highscore:int = 0
var _score:int = 0
var bugs_escaped = 0
var cur_level:int = 0

var sw_loaded = false
var is_debugmode = false 

const LOCAL_MARKER_FILE = "res://debug/do_not_delete.txt"

func _ready():
	check_if_local()

	if is_online:
		init_silentwolf()
		await load_leaderboard_SW()
	else:
		load_leaderboard()
	# SignalManager.level_complete.connect(on_level_complete)
	SignalManager.on_game_over.connect(_on_game_over)
	SignalManager.level_complete.connect(_on_level_complete)
	SignalManager.pickup_bug.connect(_pickup_bug)
	SignalManager.gain_points.connect(_gain_points)
	SignalManager.loose_points.connect(_loose_points)
	SignalManager.bug_escaped.connect(_bug_escaped)


func check_if_local():
	if FileAccess.file_exists(LOCAL_MARKER_FILE):
		is_debugmode = true
		
	print("debugmode: %s" % is_debugmode)


# =================================
# silent wolf 
# =================================

func init_silentwolf():
	SilentWolf.configure({
		"api_key": YOUR_SILENTWOLF_API_KEY,
		"game_id": YOUR_SILENTWOLF_GAME_ID,
		"log_level": 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://game/ui/main_screen.tscn"
	})


func save_score_SW():
	if is_debugmode:
		print("debugmode. not saving scores")
	else:
		print("no debug mode")
		var player_name = cur_playername
		var score = _score
		var ldboard_name = "main"
		var metadata = {
			"level": cur_level
		}
		SilentWolf.Scores.save_score(player_name, score, ldboard_name, metadata)
		SignalManager.sw_loaded.emit()


func load_leaderboard_SW():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	for entry in sw_result["scores"]:
		var line = {
			PLAYERNAME_KEY: entry["player_name"], 
			SCORE_KEY: entry["score"], 
			LEVEL_KEY: entry["metadata"]["level"]
		}
		leaderboard_table.append(line)
	sw_loaded = true
	# sort_table()
	# SignalManager.sw_loaded.emit()

# =================================
# current game 
# =================================

func get_score() -> int:
	return _score


func reset_score():
	_score = 0
	cur_level = 1
	bugs_escaped = 0
	SignalManager.on_score_updated.emit()


func update_score(points: int):
	if (_score + points) > 0:
		_score += points
		if _highscore < _score:
			_highscore = _score
		SignalManager.on_score_updated.emit()
	#print("update score: %s" % _score)


'''
func set_score(score:int):
	_score = score
'''

func set_level(levelnumber:int):
	cur_level = levelnumber


func set_playername(playername:String):
	cur_playername = playername


# =================================
# leaderboard
# =================================

func load_leaderboard():
	if is_online:
		await load_leaderboard_SW()
	else:
		if not FileAccess.file_exists(HIGHSCORE_FILE):
			print("File not found")
			return
		var json = JSON.new()
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.READ)
		var content = file.get_as_text()
		
		var error = json.parse(content)
		if error == OK:
			var data_received = json.data
			if typeof(data_received) == TYPE_ARRAY:
				leaderboard_table = data_received
				sort_table()
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())


func get_score_table():
	'''
	if is_online and not sw_loaded:
		await load_leaderboard_SW()
	'''
	sort_table()
	return leaderboard_table


func add_entry():
	if not GameManager._is_training:
		if is_online:
			save_score_SW()
		else:
			var entry = {
				PLAYERNAME_KEY: cur_playername,
				SCORE_KEY: _score,
				LEVEL_KEY: cur_level
			}
			leaderboard_table.append(entry)
			sort_table()
			if leaderboard_table.size() > max_entries:
				leaderboard_table.pop_back()
			
			var index = _find_index()
			save_leaderboard()


func get_highscore() -> int:
	if leaderboard_table.size() > 0:
		return leaderboard_table[0][SCORE_KEY]
	else:
		return 0


func _find_index():
	var index = 0
	for e in leaderboard_table:
		index += 1
		if e[SCORE_KEY] == _score and e[PLAYERNAME_KEY] == cur_playername and e[LEVEL_KEY] == cur_level:
			return index
	return -1


func save_leaderboard():
	if not GameManager._is_training:
		var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.WRITE)
		var json_string = JSON.stringify(leaderboard_table)
		file.store_string(json_string)


func sort_table():
	leaderboard_table.sort_custom(_sort_desc)


func _sort_desc(a, b):
	if a[SCORE_KEY] > b[SCORE_KEY]:
		return true
	return false
	

# =================================
# Signals
# =================================


func _bug_escaped():
	bugs_escaped += 1


func _loose_points(points: int):
	update_score(-points)


func _gain_points(points: int):
	update_score(points)


func _pickup_bug(points:int):
	_gain_points(points)


func _on_level_complete():
	save_leaderboard()


func _on_game_over():
	add_entry()
	save_leaderboard()
	#_score = 0
