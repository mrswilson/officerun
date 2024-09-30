extends PanelContainer
class_name AlarmCounter

var hotspot:Hotspot
@onready var icon = $HB/icon
@onready var label = $HB/Label
#@onready var animation_player = $HB/AnimationPlayer
@onready var alarm_counter = $"."
@onready var damage_timer = $damageTimer

const COLOR_RED = "ff7066"
const COLOR_YELLOW = "eff09e"

func _ready():
	hide()
	#pass


func set_hotspot(alarm_hotspot:Hotspot):
	hotspot = alarm_hotspot
	# label.text = hotspot.hotspot_name
	#label.text = "-%s" % hotspot.damage_points
	label.text = hotspot.alarm_message
	icon.texture = hotspot.alarm_icon
	
	hotspot.hotspot_alarm_started.connect(_on_hotspot_alarm_started)
	hotspot.hotspot_damage.connect(_on_hotspot_damage)
	hotspot.hotspot_alarm_off.connect(_on_hotspot_alarm_off)

# wenn der Alarm gestartet wird, das Label anzeigen
# wenn es schaden gibt, den Punktabzug füx x Sekunden anzeigen
# danach wieder den Hotspotnamen anzeigen

func _on_hotspot_alarm_started(hs_name:String):
	if hs_name == hotspot.hotspot_name:
		label.text = hotspot.alarm_message
		show()


func _on_hotspot_damage(hs_name:String, damage_points:int):
	if hs_name == hotspot.hotspot_name:
		damage_timer.start()
		self.modulate = Color(COLOR_RED)
		label.text = "-%s" % damage_points


func _on_hotspot_alarm_off(hs_name:String):
	if hs_name == hotspot.hotspot_name:
		modulate = Color(COLOR_YELLOW)
		damage_timer.stop()
		hide()


func _on_damage_timer_timeout():
	# after damage was shown, reset label to hotspotname
	label.text = hotspot.alarm_message
