extends CharacterBody2D

class_name Player

# @onready var dude = $dude
# @onready var dude = $retrosprite
@onready var dude = $nerd

# @onready var pickup_timer = $pickupTimer
@onready var timer_bar = $timerBar
@onready var progress_timer = $progressTimer
var PROGRESS_TIME:float = 0.7
var PICKUP_TIME:float = 0.7

# @onready var sound_player = $SoundPlayer
# @onready var audio_stream_player_2d = $AudioStreamPlayer2D

@export var RUN_SPEED: float = 120.0
var acceleration:int = 120
# @export var JUMP_VELOCITY: float = -200.0

const UP = "_up"
const DOWN = "_down"
const LEFT = "_left"
const RIGHT = "_right"
const IDLE = "idle"
const RUN = "run"
const HURT = "hurt"
const PICK = "pick"
const DIE = "die"
const PROGRESS = "progress"
const PAUSE = "pause"

# enum PLAYER_STATE { IDLE, RUN, HURT}
# var _state : PLAYER_STATE = PLAYER_STATE.IDLE
var _state:String = IDLE
var direction:String = DOWN

func _ready():
	# start_position = position
	SignalManager.pickup_bug.connect(_pickup)
	SignalManager.on_game_over.connect(_on_game_over)
	SignalManager.level_completed.connect(_on_level_complete)
	SignalManager.meeting_started.connect(_on_meeting_started)
	SignalManager.vb_entry.connect(_phonecall)
	SignalManager.pause_player.connect(_pause_player)
	# SignalManager.on_player_hit.emit(_lives)


func _physics_process(_delta):
	get_input()
	calculate_states()
	move_and_slide()
	update_progressbar()


func update_progressbar():
	'''
	if _state == PICK:
		timer_bar.value = (pickup_timer.time_left / PICKUP_TIME) * 100
	'''
	if _state == PROGRESS: # or _state == PICK:
		timer_bar.value = (progress_timer.time_left / PROGRESS_TIME) * 100


func _pause_player(duration, show_progress:bool):
	timer_bar.hide()
	await pause_player_action(duration)
	

func pause_player(pauseit:bool):
	if pauseit:
		set_state(PAUSE)
	else:
		set_state(IDLE)


func pause_player_action(time:float, animation:String=IDLE):
	timer_bar.visible = true
	PROGRESS_TIME = time
	progress_timer.start(time)
	velocity = Vector2.ZERO
	set_state(PROGRESS)

	var anim = animation + direction
	dude.play(anim)

	await get_tree().create_timer(time).timeout
	set_state(IDLE)


func _pickup(_points:int):
	# SoundManager.play_clip(audio_stream_player_2d, SoundManager.BUG_COLLECTED)
	await pause_player_action(PICKUP_TIME, PICK)


func get_input():
	# if _state == HURT or _state == PICK or _state == PROGRESS:
	if _state == PROGRESS or _state == PAUSE:
		return
	
	var input_vector := Vector2(
		float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
		float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	)
	velocity.x = move_toward(velocity.x, RUN_SPEED * input_vector.x, acceleration)
	velocity.y = move_toward(velocity.y, RUN_SPEED * input_vector.y, acceleration)
	
	if velocity.x < 0:
		direction = LEFT
	elif velocity.x > 0:
		direction = RIGHT
	elif velocity.y > 0:
		direction = DOWN
	elif velocity.y < 0:
		direction = UP


func calculate_states():
	# if _state == HURT or _state == PICK or _state == PROGRESS:
	if _state == PROGRESS:
		return
	if velocity.x == 0 and velocity.y == 0:
		set_state(IDLE)
	else:
		set_state(RUN)


func  set_state(new_state):
	_state = new_state
	match _state:
		IDLE:
			dude.play(IDLE + direction)
		RUN:
			dude.play(RUN + direction)


func _on_meeting_over():
	pass


func _on_meeting_started():
	pass


func _phonecall():
	pause_player_action(0.5, PICK)


func _on_game_over():
	set_physics_process(false)


func _on_level_complete():
	set_process(false)
	set_physics_process(false)
	dude.stop()


func _on_progress_timer_timeout():
	timer_bar.visible = false
