extends HBoxContainer
class_name ItemCounter

@export var image_inactive:Texture2D
@export var image_active:Texture2D

@export_range(1, 10) var max_count:int = 5
@export var title:String = ""

@onready var template_item:TextureRect = $item
@onready var item_counter = $"."
@onready var label = $Label
@onready var reset_timer:Timer = $reset_timer
# @onready var audio_stream_player_2d = $AudioStreamPlayer2D

var items:Array[TextureRect] = []
var no_of_active_items = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = tr(title)
	template_item.texture = image_inactive
	template_item.offset_bottom = template_item.size.y / 2
	template_item.offset_left = template_item.size.x / 2
	
	items.append(template_item)
	for i in range(0, max_count-1):
		var new_item = template_item.duplicate()
		items.append(new_item)
		item_counter.add_child(new_item)


func set_no_of_active_items(no_of_active:int):
	no_of_active_items = no_of_active
	for i in range(0, no_of_active):
		var myitem = items[i]
		myitem.texture = image_active


func reset():
	reset_timer.start()
	

func increase():
	if (no_of_active_items < items.size()):
		var myitem = items[no_of_active_items]
		await _popup(myitem)
		myitem.texture = image_active
		no_of_active_items += 1


func _popup(item):
	var tween:Tween = get_tree().create_tween()

	var delta_value = Vector2(1.5, 1.5)
	var duration = 0.2
	var trans_type = Tween.TRANS_ELASTIC
	var ease_type = Tween.EASE_IN

	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
	
	delta_value = Vector2(0.8, 0.8)
	duration = 0.1
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)
		
	delta_value = Vector2(1, 1)
	duration = 0.2
	tween.tween_property(item, "scale", delta_value, duration).set_trans(trans_type).set_ease(ease_type)


func decrease():
	if no_of_active_items > 0:
		items[no_of_active_items-1].texture = image_inactive
		no_of_active_items -= 1
	else:
		reset_timer.stop()


func _on_reset_timer_timeout():
	decrease()
	if no_of_active_items > 0:
		reset_timer.start()
