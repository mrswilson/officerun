extends Node2D
class_name BugSpawner
# === elements ===

var MyBuggy = preload("res://game/Bugs/bug.tscn")
@onready var spawn_bug_timer = $SpawnBugTimer


# === properties === 

@export var active:bool = true
@export var interval_min = 3
@export var interval_max = 8
@export var speed:float = 20
@export_range(0, 10) var max_waypoints_for_bugs:int = 2

@export var waypointsNode:Node2D
@export var exit:Marker2D


func _ready():
	SignalManager.pause_bugs.connect(_pause)
	if interval_min == 0:
		spawn_bug_timer.wait_time = 0.1
	else:
		spawn_bug_timer.wait_time = randi_range(interval_min, interval_max)
	SignalManager.on_game_over.connect(_on_game_over)
	SignalManager.level_completed.connect(_on_level_complete)
	

func spawn_bugs(amount:int, breaktime:float=0):
	for i in range(0, amount):
		var bug = MyBuggy.instantiate()
		# var bug = Bug.new()
		
		var waypoints = get_waypoints()
		bug.speed = speed
		if max_waypoints_for_bugs > waypoints.size():
			max_waypoints_for_bugs = waypoints.size()
		bug.max_waypoints = max_waypoints_for_bugs
		get_parent().add_child(bug)
		bug.global_position = global_position
		bug.exit = exit
		#if max_waypoints_for_bugs > 0:
		bug.set_waypoints(waypoints.duplicate())
		bug.set_speed(self.speed)
		if breaktime > 0:
			await get_tree().create_timer(breaktime).timeout

func spawn_enemy():
	if active:
		spawn_bugs(1)
		'''
		var bug = MyBuggy.instantiate()
		# var bug = Bug.new()
		
		var waypoints = get_waypoints()
		bug.speed = speed
		if max_waypoints_for_bugs > waypoints.size():
			max_waypoints_for_bugs = waypoints.size()
		bug.max_waypoints = max_waypoints_for_bugs
		get_parent().add_child(bug)
		bug.global_position = global_position
		bug.exit = exit
		bug.set_waypoints(waypoints.duplicate())
		bug.set_speed(self.speed)
		'''
		spawn_bug_timer.wait_time = randi_range(interval_min, interval_max)


func get_waypoints():
	var wp:Array[Marker2D] = []
	if waypointsNode:
		var children = waypointsNode.get_children()
		for c in children:
			if is_instance_of(c, Marker2D):
				wp.append(c)
	return wp


func _stop_spawning():
	set_physics_process(false)
	# spawn_bug_timer.set_wait_time(0)
	spawn_bug_timer.stop()

# === Signals ===

func _pause(pause):
	if pause:
		spawn_bug_timer.stop()
	else:
		spawn_bug_timer.start()

func _on_spawn_bug_timer_timeout():
	spawn_enemy()


func _on_game_over():
	set_physics_process(false)
	_stop_spawning()


func _on_level_complete():
	set_physics_process(false)
	_stop_spawning()
