extends Control

@onready var health_label = $health_label

func _ready() -> void:
	health_label.text = str(GlobalStuff.SCORE)

func _process(delta: float) -> void:
	update_health()

func update_health():
	health_label.text = "Health: " + str(GlobalStuff.PLAYER_HEALTH)
