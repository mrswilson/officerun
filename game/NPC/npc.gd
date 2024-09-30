extends CharacterBody2D
class_name  NPC

@onready var sprite = $sprite
@onready var animation_player = $AnimationPlayer

@export var spritesheet:Texture2D
@export var speed:int = 70
@export var waypointsNode:Node2D
var waypoints : Array[Marker2D]

@onready var nav_agent = $Navigation/navAgent
#var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	if spritesheet:
		sprite.texture = spritesheet
	animation_player.play("walk_left")
	waypoints = read_waypoints()
	speed = randf_range(speed * 0.9, speed * 1.2)
	make_path()


func _physics_process(_delta:float):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	move_and_slide()


func make_path():
	nav_agent.target_position = waypoints.pick_random().global_position


func read_waypoints():
	var wp:Array[Marker2D] = []
	if waypointsNode:
		var children = waypointsNode.get_children()
		for c in children:
			if is_instance_of(c, Marker2D):
				wp.append(c)
	return wp


func _on_nav_agent_navigation_finished():
	make_path()
