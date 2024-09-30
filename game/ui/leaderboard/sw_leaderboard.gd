extends SWLeaderboard

const SWScoreItem = preload("res://game/ui/leaderboard/leaderboard_entry.tscn")
@onready var close_button_2 = $Board/CloseButtonContainer/CloseButton2

func _ready():
	super._ready()
	

func add_item(player_name: String, score_value: String) -> void:
	var item = SWScoreItem.instantiate()
	list_index += 1
	item.get_node("HB/labelRank").text = str(list_index)
	#item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("HB/labelName").text = player_name
	item.get_node("HB/labelScore").text = score_value
	item.offset_top = list_index * 100
	$"Board/HighScores/ScoreItemContainer".add_child(item)


func _on_close_button_2_pressed():
	hide()


func _on_close_button_2_visibility_changed():
	if visible:
		#await setup_table()
		if close_button_2:
			close_button_2.grab_focus()
		
