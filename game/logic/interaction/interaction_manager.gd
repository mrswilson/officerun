extends Node2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label


const base_text:String = "[E] to"

var active_areas:Array = []
var can_interact:bool = true


func _process(_delta):
	if active_areas.size() > 1 and can_interact:
		active_areas.sort_custom(_sort_by_dist_to_player)
		'''
		var area:InteractionArea = active_areas[0]
		label.text = base_text + area.action_name
		label.global_position = area.global_position
		label.global_position.y -= 36
		label.global_position.x = label.size.x / 2
		label.show()
		'''
	else:
		label.hide()


func _sort_by_dist_to_player(area1, area2):
	if player:
		var area1_to_player = player.global_position.distance_to(area1.global_position)
		var area2_to_player = player.global_position.distance_to(area2.global_position)
		return area1_to_player < area2_to_player
	return 0


func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			var ia = active_areas[0].interact
			await ia.call()
			can_interact = true


func register_area(area:InteractionArea):
	active_areas.push_back(area)
	SignalManager.interaction_area_entered.emit(area)
	

func unregister_area(area:InteractionArea):
	var index = active_areas.find(area)
	if index >= 0:
		active_areas.remove_at(index)
		SignalManager.interaction_area_exit.emit(area)
