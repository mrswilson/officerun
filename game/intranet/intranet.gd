extends Node2D

@onready var interaction_area = $InteractionArea
@onready var collision_marker = $InteractionArea/collisionMarker
@onready var timer = $Timer

@onready var intranetbeitrag = $CanvasLayer/Intranetbeitrag
@onready var entrylabel = $CanvasLayer/Intranetbeitrag/MarginContainer/VBoxContainer/entrylabel
@onready var pressley = $CanvasLayer/Intranetbeitrag/MarginContainer/VBoxContainer/pressley


const INTRANET_FILE = "res://translation/Godot_Officerun - intranet.csv"

var intranet_entries = []
var readingtime 
var is_reading:bool = false

var done_reading:bool = false # der Beitrag kann nur einmal gelesen werden. 
var readingtime_over = false

func _ready():
	interaction_area.interact = Callable(self, "_interact")
	interaction_area.set_active(true)
	collision_marker.hide()
	intranetbeitrag.hide()
	pressley.hide()
	
	init_entries()


func _process(delta):
	if readingtime_over and intranetbeitrag.visible:
		if Input.is_anything_pressed():
			close_intranet()


func close_intranet():
	intranetbeitrag.hide()
	readingtime_over = true
	#SignalManager.minimap_show.emit()
	SignalManager.read_intranet_stop.emit()
	SignalManager.gain_points.emit(20)


func init_entries():
	var found:bool = true
	
	if not FileAccess.file_exists(INTRANET_FILE):
		print("File not found")
		return
	var json = JSON.new()
	var file = FileAccess.open(INTRANET_FILE, FileAccess.READ)
	var content = file.get_as_text()
	var no_of_lines:int = content.split("\n").size()
	var text = ""
	for index in range(1, no_of_lines):
		text = tr("INTRANET_BEITRAG_%d" % index)
		intranet_entries.append(text)


func _interact():
	if not is_reading and not done_reading:
		set_random_entry()
		SignalManager.pause_player.emit(readingtime, false)
		#SignalManager.minimap_hide.emit()
		SignalManager.read_intranet_start.emit()
		intranetbeitrag.show()
		is_reading = true
		timer.start()
		done_reading = true

func set_random_entry():
	var entry = intranet_entries.pick_random()
	# speed: 3 words per second
	readingtime = entry.split(" ").size() / 3
	timer.wait_time = readingtime 
	entrylabel.text = entry


func _on_timer_timeout():
	is_reading = false
	readingtime_over = true
	pressley.show()

func _on_interaction_area_body_exited(_body):
	collision_marker.hide()


func _on_interaction_area_body_entered(body):
	if not done_reading:
		collision_marker.show()

