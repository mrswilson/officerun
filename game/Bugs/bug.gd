extends CharacterBody2D
class_name Bug

@onready var nav_agent = $Navigation/NavigationAgent2D

@onready var circle_animation = $Interaction/circle_animation
@onready var interaction_area = $Interaction/InteractionArea
@onready var circle = $Interaction/circle

@onready var roach = $roach
@onready var label_animation = $labelNode/labelAnimation
@onready var points_label = $labelNode/pointsLabel

@onready var animation_player = $AnimationPlayer
@onready var sound_player = $soundPlayer

@export var points:int = 5
@export var speed:int = 50
@export var waypoints : Array[Marker2D]
@export var exit:Marker2D


var cur_goal_index:int = 0
var selected_goals = []
var max_waypoints:int = 2 # max number of possible waypoints, before bug goes to exit
var no_of_goals # actual random number of waypoints, <= max_waypoints 

# var points_hotfix = 5*points
# var _speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_pick")
	SignalManager.interaction_area_entered.connect(_interaction_area_entered)
	SignalManager.interaction_area_exit.connect(_interaction_area_exit)
	circle.visible = false

	SignalManager.on_game_over.connect(_on_game_over)
	SignalManager.level_completed.connect(_on_level_complete)
	animation_player.play("run")
	if waypoints.size() > 0 and max_waypoints > 0:
		set_waypoints(waypoints)


func set_waypoints(newwaypoints:Array[Marker2D]):
	no_of_goals = randi_range(1, max_waypoints)
	newwaypoints.shuffle()
	for i in range(0, no_of_goals):
		var wp = newwaypoints[i]
		selected_goals.append(wp)
	make_path()


func _physics_process(_delta:float):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()


func set_speed(newspeed:int):
	self.speed = newspeed


func get_speed():
	return self.speed


func _stop_moving():
	set_physics_process(false)
	speed = 0
	# roach.stop()


func _pick():
	self.speed = 0	
	SignalManager.pickup_bug.emit(points)
	points_label.text = str(points)
	label_animation.play("popup")
	sound_player.play()
	await get_tree().create_timer(0.5).timeout
	#await sound_player.finished # this ine does not seem to work when there's a problem with the soundcard. the next line won't be called then.
	self.queue_free()


func _blink(blink:bool):
	circle.visible = blink
	if blink:
		circle_animation.play("blink")


func make_path():
	# print("cur_goal index: %d (size: %d)" % [cur_goal_index, selected_goals.size()])
	# if cur_goal_index > selected_goals.size()-1:
	if cur_goal_index == no_of_goals:
		#print("going to exit")
		nav_agent.target_position = exit.global_position
	else:
		#print("heading for new waypoint")
		nav_agent.target_position = selected_goals[cur_goal_index].global_position
		

# ====================================================
# Signals
# ====================================================

func _on_game_over():
	set_physics_process(false)


func _on_level_complete():
	_stop_moving()


func _interaction_area_entered(area):
	if area == interaction_area:
		_blink(true)


func _interaction_area_exit(area):
	if area == interaction_area:
		_blink(false)


func _on_navigation_agent_2d_navigation_finished():
	if cur_goal_index == no_of_goals:
		SignalManager.bug_escaped.emit()
		queue_free()
	elif cur_goal_index < no_of_goals:
		cur_goal_index += 1
		make_path()


