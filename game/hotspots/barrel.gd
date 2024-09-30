extends Hotspot

@onready var bug_spawner:BugSpawner = $Bugs/BugSpawner
#@onready var bug_timer = $Bugs/bugTimer
@onready var barrel_sprite = $barrelSprite


var is_active:bool = false
@export var waypointsNode:Node2D
@export var exit:Marker2D


func _ready():
	super._ready()
	bug_spawner.waypointsNode = waypointsNode
	bug_spawner.exit = exit
	bug_spawner.active = false


func _interact():
	if not is_active:
		SignalManager.barrel_activated.emit()
		is_active = true
	else:
		# Fass aufmachen
		barrel_sprite.play("bang")


func calc_result():
	var val = randi_range(1, 5)
	match val:
		1: 
			var barrel_points = randi_range(points, points*2) * 5
			SignalManager.gain_points.emit(barrel_points)
		_: 
			is_active = false
			bug_spawner.spawn_bugs(10, 0.2)
	await get_tree().create_timer(1).timeout
	barrel_sprite.visible = false
	interaction_area.queue_free()
	sprite_collision.queue_free()
	# queue_free()


func _on_interaction_area_body_exited(_body):
	is_active = false
	SignalManager.hide_messages.emit()
	# bug_timer.start()


func _on_bug_timer_timeout():
	bug_spawner.active = false
	queue_free()
	

func _on_barrel_sprite_animation_finished():
	calc_result()
