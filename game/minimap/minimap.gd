extends MarginContainer
class_name Minimap

@export var player:Player
@export var zoom = 1.5
@export var show_map:bool = true

@onready var grid = $MC/Grid

@onready var player_marker = $MC/Grid/PlayerMarker
@onready var bas_marker = $MC/Grid/BASMarker
@onready var alarm_marker = $MC/Grid/AlarmMarker
@onready var phone_marker = $MC/Grid/PhoneMarker
@onready var server_marker = $MC/Grid/ServerMarker


@onready var icons = {
	"bas": bas_marker,
	"alarm": alarm_marker,
	"phone": phone_marker,
	"server": server_marker
}

var grid_scale
var markers = {}


func _ready():
	if show_map:
		await get_tree().process_frame
		player_marker.position = grid.size / 2
		grid_scale = grid.size / (get_viewport_rect().size * zoom)

		var map_objects = get_tree().get_nodes_in_group("minimap_objects")
		for item in map_objects:
			
			var new_marker = icons[item.minimap_icon].duplicate()
			grid.add_child(new_marker)
			new_marker.show()
			markers[item] = new_marker


func _process(_delta):
	if show_map:
		if !player:
			return
				
		for item in markers:
			if item.is_alarm:
				item.visible = true
				var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2
				obj_pos = obj_pos.clamp(Vector2.ZERO, grid.size)
				markers[item].position = obj_pos
				if grid.get_rect().has_point(obj_pos + grid.position):
					markers[item].scale = Vector2(1, 1)
				else:
					markers[item].scale = Vector2(0.75, 0.75)
				markers[item].visible = true
			else:
				markers[item].visible = false
