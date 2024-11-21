extends Control

@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/Vol_Slider
var master_bus_index = 0
var current_volume_value = GlobalStuff.GLOBAL_VOLUME


func _ready() -> void:
	var current_volume_db = AudioServer.get_bus_volume_db(master_bus_index)
	$High_Score.text = "High Score: "+ str(GlobalStuff.high_score)
	volume_slider.value = GlobalStuff.GLOBAL_VOLUME
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Main_Level.tscn")
	

func _on_scores_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()

func slider_value_to_db(slider_value: float) -> float:
	return lerp(-20, 0, slider_value / 100)

func _on_vol_slider_value_changed(value:float) -> void:
	# Map slider value (0-100) to decibels
	var volume_db = slider_value_to_db(value)
	AudioServer.set_bus_volume_db(master_bus_index, volume_db)
	GlobalStuff.GLOBAL_VOLUME = value

# Helper function: Map decibels (-20 to 0) to slider value (0-100)
func db_to_slider_value(volume_db: float) -> float:
	return inverse_lerp(-20, 0, volume_db)
