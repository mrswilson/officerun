extends Node


'''
const SIMPLE_SCENES = {
	SCENE_KEY.EXPLOSION: preload("res://Game/Explosion/enemy_explosion.tscn"),
	SCENE_KEY.PICKUP: preload("res://Game/Levels/fruit_pickup/fruit_pickup.tscn")
}
'''

func add_child_deferred(child_to_add):
	get_tree().root.add_child(child_to_add)


func call_add_child(child_to_add):
	call_deferred("add_child_deferred", child_to_add)



'''
func create_explosion(position: Vector2):
	var new_explosion = explosion_scene.instantiate()
	new_explosion.global_position = position
	call_add_child(new_explosion)


func create_pickup(position: Vector2):
	var new_pickup = pickup_scene.instantiate()
	new_pickup.global_position = position
	call_add_child(new_pickup)

func create_simple_scene(key: SCENE_KEY, position: Vector2):
	var new_scene = SIMPLE_SCENES[key].instantiate()
	new_scene.global_position = position
	call_add_child(new_scene)
'''

