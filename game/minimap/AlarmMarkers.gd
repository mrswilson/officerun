extends Node2D

@onready var player = $"../Player"
@onready var hotspots = $"../Hotspots"
@onready var marker = $marker

var viewport_center:Vector2 

var vp_pos_x = 0
var vp_pos_y = 0
var vp_width = 320
var vp_height = 240

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_center = get_viewport().get_visible_rect().get_center()


func _show_alarm():
	if hotspots.get_child_count() > 0:
		for hs in hotspots.get_children():
			if hs.show_alarm_marker:
				var hotspot_position = hs.global_position
				var pos = check_alarm(player.global_position, hotspot_position)
				marker.global_position = pos
				marker.visible = true


func check_alarm(player_pos:Vector2, server_pos:Vector2) -> Vector2:
	var vec = player_pos - server_pos
	var point:Vector2 = Vector2(0, 0)
	
	var y_val = get_viewport_rect().get_center().y
	var x_val = get_viewport_rect().get_center().x
	
	if vec.x > x_val:
		point.x = get_viewport_rect().get_center().x
		point.y = player_pos.y + ((x_val - player_pos.x)/vec.x) * vec.y
	elif vec.x < -(x_val):
		point.x = -(get_viewport_rect().get_center().x)
		point.y = player_pos.y - ((x_val - player_pos.x)/vec.x) * vec.y
	
	if vec.y > y_val:
		point.y = get_viewport_rect().get_center().y
		point.x = player_pos.x + ((y_val - player_pos.y)/vec.y) * vec.x
	elif vec.y < -(y_val):
		point.y = -(get_viewport_rect().get_center().y)
		point.x = player_pos.x - ((y_val - player_pos.y)/vec.y) * vec.x
		
	if point.y < -180:
		point.y = -180
	elif point.y > 180:
		point.y = 180
	if point.x < -320:
		point.x = -320
	elif point.x > 320:
		point.x = 320
	
	return point
