class_name Healthcomponent extends Node2D

@onready var hit_effect = preload("res://Scenes/Entities/enemy_hit_particle.tscn")
@export var max_health = 100
var health: float 
signal took_damage(intensity: float, duration: float)
signal kill_player(amount: int)
signal update_health

func _ready() -> void:
	health = max_health

func damage(attack: Attack):
	health -= attack.damage
	get_parent().get_node("AnimatedSprite2D").modulate = Color('0015ff')
	await get_tree().create_timer(0.1).timeout  # Optional delay to reset color
	get_parent().get_node("AnimatedSprite2D").modulate = Color.WHITE
	if get_parent().has_method('Player'):
		took_damage.emit(5,0.5)
		update_health.emit()
		# took_damage_2.emit(3) # in case of emergency
	if health <= 0 and get_parent().has_method('Enemy'):
		GlobalStuff.SCORE += 1
		# Instantiate the particle effect
		var hit_effect_instance = hit_effect.instantiate()
		get_parent().get_parent().add_child(hit_effect_instance)
		hit_effect_instance.global_position = get_parent().global_position  # Set its position
		# Add the particle effect to the scene tree
		print(get_parent().global_position,hit_effect_instance.global_position)
		get_parent().queue_free()
	elif health <= 0 and get_parent().has_method('Player'):
		kill_player.emit(3) # in case of emergency


func increase(amount):
	health += amount
	if health >=max_health:
		health = max_health
