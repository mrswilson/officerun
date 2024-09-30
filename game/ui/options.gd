extends MainscreenOverlay
class_name OptionScene

@onready var lang_button = $MC/VB/VBoxContainer/HBLanguage/langButton

@onready var SOUND_BUS_INDEX = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_INDEX = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_INDEX = AudioServer.get_bus_index("Music")

var languages = {
		"Deutsch": "de",
		"English": "en"
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	for lang in languages:
		# Insert the key and value into a text string
		lang_button.add_item(lang)
	lang_button.grab_focus()



func _on_option_button_item_selected(index):
	var locale : String = lang_button.get_item_text(index)
	var val = languages[locale]
	TranslationServer.set_locale(val) # and change the TranslationServer in runtime


func _on_cb_music_toggled(toggled_on):
	GameManager.play_music(toggled_on)


func _on_close_button_pressed():
	#get_parent().visible = false
	hide()


# overall sound
func _on_sound_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SOUND_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(SOUND_BUS_INDEX, value < 0.05)


# music volume
func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_INDEX, value < 0.05)

# sound effects volume
func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_INDEX, value < 0.05)
