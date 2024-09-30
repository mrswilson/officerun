extends Node


const GROUP_PLAYER: String = "player"

var TOTAL_LEVELS: int = 5
const MAIN_SCENE: PackedScene = preload("res://game/ui/main_screen.tscn")
const GAME_START_SCENE: PackedScene = preload("res://game/ui/gamestart/game_start.tscn")
const GAME_OVER_SCENE: PackedScene = preload("res://game/ui/gameover/game_over.tscn")
const CREDIT_SCENE:  PackedScene = preload("res://game/ui/credits.tscn")
const LEVEL_LIST:  PackedScene = preload("res://game/ui/levellist/level_list.tscn")


var _current_level: int = 0
var _level_scenes = {}
var _is_training = true # true, wenn nur EIN Level gespielt wird. Dann wird danach nicht das nächste geladen

var opt_play_music:bool = true

const LOCAL_MARKER_FILE = "res://do_not_delete.txt"
var is_debugmode = false 

func _ready():
	init_level_scenes()
	#ScoreManager.reset_score()
	LeaderboardManager.reset_score()
	SignalManager.bugfix.connect(_bugfix)
	check_if_local()

func check_if_local():
	if FileAccess.file_exists(LOCAL_MARKER_FILE):
		is_debugmode = true



func init_level_scenes():
	for ln in range(1, TOTAL_LEVELS + 1):
		_level_scenes[ln] = load("res://game/levels/level_%s.tscn" % ln)
	'''
	var ln:int = 1
	var level_found:bool = true
	print("initializing levels")
	while level_found:
		var filename = "res://game/levels/level_%s.tscn" % ln
		print("-> filename: %s" % filename)
		if FileAccess.file_exists(filename):
			_level_scenes[ln] = load(filename)
			ln += 1
		else:
			level_found = false
	print(_level_scenes)
	TOTAL_LEVELS = _level_scenes.size()
	'''


func get_levellist():
	return _level_scenes


func load_main_scene():
	_current_level = 0
	LeaderboardManager.reset_score()
	get_tree().change_scene_to_packed(MAIN_SCENE)


func load_next_level_scene():
	if not _is_training:
		set_next_level()
		get_tree().change_scene_to_packed(_level_scenes[_current_level])
	else:
		load_main_scene()

func start_game():
	_is_training = false
	_current_level = 0
	get_tree().change_scene_to_packed(GAME_START_SCENE)


func restart_level():
	load_level_scene(_current_level)


func load_level_scene(levelnumber:int):
	_current_level = levelnumber
	_is_training = true
	var scene = _level_scenes[levelnumber]
	get_tree().change_scene_to_packed(scene)


func show_game_over():
	#_current_level = 0
	'''
	if _is_training:
		load_main_scene()
	else:
	'''
	get_tree().change_scene_to_packed(GAME_OVER_SCENE)


func show_credits():
	get_tree().change_scene_to_packed(CREDIT_SCENE)


func show_levellist():
	get_tree().change_scene_to_packed(LEVEL_LIST)
	

func play_music(playit:bool):
	opt_play_music = playit


func set_next_level():
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		_current_level = 1


func _bugfix():
	pass
