extends Control
class_name LeaderboardEntry


@onready var label_rank = $HB/labelRank
@onready var label_name = $HB/labelName
@onready var label_score = $HB/labelScore
@onready var label_level = $HB/labelLevel


func init(playername, score, level, rank=""):
	label_rank.text = "%02d" % rank
	label_name.text = playername
	label_score.text = "%04d" % score
	label_level.text = "%02d" % level
