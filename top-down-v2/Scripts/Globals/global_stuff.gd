extends Node

var ENEMY_COUNT = 0
var SCORE = 0
var WAVE_NUMBER = 0
var PLAYER_HEALTH = 100
@onready var GLOBAL_VOLUME = 100
@onready var save_data: SaveData = SaveData.load_or_create()
@onready var high_score = save_data.high_score


func _ready() -> void:
	pass
	

	
