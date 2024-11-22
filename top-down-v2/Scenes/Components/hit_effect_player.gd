class_name effects_player extends Node

@export var entity: Node2D
@onready var death_effect = preload("res://Scenes/Entities/enemy_hit_particle.tscn")

func play_hit_effect():
	entity.get_node("AnimatedSprite2D").modulate = Color('0015ff')
	await get_tree().create_timer(0.1).timeout  # Optional delay to reset color
	get_parent().get_node("AnimatedSprite2D").modulate = Color.WHITE

func play_death_effect():
	var death_effect_instance = death_effect.instantiate()
	entity.get_parent().add_child(death_effect_instance)
	death_effect_instance.global_position = entity.global_position 
	