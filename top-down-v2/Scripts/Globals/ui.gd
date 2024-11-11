extends Control

@onready var score_label = $score_label
@onready var health_label = $health_label

func _ready() -> void:
	score_label.text = str(GlobalStuff.SCORE)
	health_label.text = str(GlobalStuff.SCORE)
	

func _process(delta: float) -> void:
	update_score()
	update_health()

func update_score():
	score_label.text = "Score: " + str(GlobalStuff.SCORE)


func update_health():
	health_label.text = "Health: " + str(GlobalStuff.PLAYER_HEALTH)
