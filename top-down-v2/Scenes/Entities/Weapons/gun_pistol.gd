extends Node2D

@onready var child = get_children()[0]
@onready var bullet = preload("res://Scenes/Entities/Weapons/bullet.tscn")
@export var gun_end: Marker2D
@onready var gun_end_2: Marker2D = $AnimatedSprite2D/gun_end2



var max_dist = 20
var canshoot: bool = true
enum Modes {NORMAL, BOOSTED}
var mode: Modes


func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var dir = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	child.position = dir * min(dist, max_dist)
	child.rotation = dir.angle()
	if child.position < get_parent().position:
		child.scale.y = -1
	else:
		child.scale.y = 1
	if Input.is_action_just_pressed("fire"):
		shoot()
	
func handle_shot(type: int):
	var animation
	var sound_player
	var selected_gun_end
	if type == 1:
		animation = "fire"
		sound_player = $fire_sound
		selected_gun_end = gun_end
		sound_player.pitch_scale = randf_range(0.8,1.6)
	elif type == 2:
		animation = "fire_2"
		sound_player = $fire_sound2
		selected_gun_end = gun_end_2

	$AnimatedSprite2D.play(animation)
	sound_player.play()
	var new_parent = get_tree().get_root().get_node("Test_Level").get_node("TileMap")
	var bullet = bullet.instantiate()
	var direction = (global_position - get_global_mouse_position()).normalized()
	bullet.position = selected_gun_end.global_position
	bullet.projectile_direction = direction
	bullet.rotation = direction.angle()
	new_parent.add_child(bullet)
	canshoot = false
	$shoot_cooldown.start()


func shoot():
	if canshoot and mode == Modes.NORMAL:
		handle_shot(1)
	elif canshoot and mode == Modes.BOOSTED:
		handle_shot(2)


func _on_shoot_cooldown_timeout() -> void:
	canshoot = true
