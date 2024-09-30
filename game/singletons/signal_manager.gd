extends Node

signal level_start
signal level_completed
signal level_complete
signal on_game_over
signal on_score_updated
signal on_escalation

signal sw_loaded

signal gain_points(points:int)
signal loose_points(points:int)


signal read_intranet_start
signal read_intranet_stop

signal pause_bugs(pause)
signal bug_escaped
signal bugfix
signal pickup_bug(points:int)

signal pause_player(duration:float, show_progress_bar:bool)

signal minimap_hide
signal minimap_show

signal barrel_activated
signal barrel_opened
signal barrel_ignored

signal vb_entry
signal meeting_started
signal meeting_over

signal interaction_area_entered
signal interaction_area_exit

signal hide_messages
