extends Area2D
class_name  InteractionArea

@export var action_name:String = "interact"
@export var markerShape:Sprite2D

@export var is_active = false 
var player_inside = false

var interact:Callable = func():
	pass


func _ready():
	if markerShape:
		markerShape.visible = false


func set_active(activate:bool):
	is_active = activate
	if markerShape and player_inside:
		markerShape.visible = is_active


# === Signals ===

func _on_body_entered(_body):
	InteractionManager.can_interact = true
	if markerShape and is_active:
		markerShape.visible = true
		player_inside = true
	InteractionManager.register_area(self)


func _on_body_exited(_body):
	if markerShape:
		markerShape.visible = false
		player_inside = false
	InteractionManager.unregister_area(self)
	
