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
	

func shoot():
	if canshoot and mode == Modes.NORMAL:
		$AnimatedSprite2D.play("fire")
		$fire_sound.pitch_scale = randf_range(0.8,1.6)
		$fire_sound.play()
		var new_parent = get_tree().get_root().get_node("Test_Level").get_node("TileMap")
		var bullet = bullet.instantiate()
		var direction = (global_position - get_global_mouse_position()).normalized()
		bullet.position = gun_end.global_position
		bullet.projectile_direction = direction
		bullet.rotation = direction.angle()
		new_parent.add_child(bullet)
		canshoot = false
		$shoot_cooldown.start()
	elif canshoot and mode == Modes.BOOSTED:
		$AnimatedSprite2D.play("fire_2")
		$fire_sound2.play()
		var new_parent = get_tree().get_root().get_node("Test_Level").get_node("TileMap")
		var bullet = bullet.instantiate()
		var direction = (global_position - get_global_mouse_position()).normalized()
		bullet.position = gun_end_2.global_position
		bullet.projectile_direction = direction
		bullet.rotation = direction.angle()
		new_parent.add_child(bullet)
		canshoot = false
		$shoot_cooldown.start()
func _on_shoot_cooldown_timeout() -> void:
	canshoot = true
