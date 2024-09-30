extends Camera2D

@onready var shake_timer = $ShakeTimer

@export var shake_amount: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	# SignalManager.on_player_hit.connect(on_player_hit)
	# SignalManager.on_game_over.connect(on_game_over)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	offset = get_random_offset()


func get_random_offset():
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)		
	)


func shake():
	set_process(true)
	shake_timer.start()


func on_player_hit(_lives: int):
	shake()


func reset_camera():
	set_process(false)
	offset = Vector2.ZERO



func _on_shake_timer_timeout():
	reset_camera()


func on_game_over():
	reset_camera()
	
