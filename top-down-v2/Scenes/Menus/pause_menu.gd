extends Control

var master_bus_index = 0
var current_volume_value = GlobalStuff.GLOBAL_VOLUME
@onready var volume_slider = $PanelContainer/VBoxContainer/Vol_Slider


func _ready() -> void:
	var current_volume_db = AudioServer.get_bus_volume_db(master_bus_index)
	$AnimationPlayer.play("RESET")
	visible = false
	self.set_process_input(false) 
	volume_slider.value = GlobalStuff.GLOBAL_VOLUME

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false
	self.set_process_input(false)
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	visible = true
	self.set_process_input(true)
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")


func _on_exit_pressed() -> void:
	resume()
	get_tree().quit()
	
func _process(delta: float) -> void:
	testEsc()

func slider_value_to_db(slider_value: float) -> float:
	return lerp(-20, 0, slider_value / 100)

func _on_vol_slider_value_changed(value:float) -> void:
	var volume_db = slider_value_to_db(value)
	AudioServer.set_bus_volume_db(master_bus_index, volume_db)
	GlobalStuff.GLOBAL_VOLUME = value