class_name Healthcomponent extends Node2D

@onready var hit_effect = preload("res://Scenes/Entities/enemy_hit_particle.tscn")
@export var max_health = 100
var health: float
var entity: Node2D
var effects_player_instance: effects_player
signal took_damage(intensity: float, duration: float)
signal kill_player(amount: int)
signal update_health

func _ready() -> void:
	health = max_health
	entity = get_parent()
	# Safely attempt to retrieve the effects_player node
	if entity.has_node("effects_player"):
		effects_player_instance = entity.get_node("effects_player")
	else:
		print("Error: 'effects_player' node not found in entity", entity)

func damage(attack: Attack):
	health -= attack.damage
	effects_player_instance.play_hit_effect()
	if entity.has_method('Player'):
		took_damage.emit(5,0.5)
		update_health.emit()
		if health <= 0:
			kill_player.emit(3)
	elif health <= 0 and !entity.has_method('Player'):
		ScoreManager.on_entity_death(entity)
		effects_player_instance.play_death_effect()
		entity.queue_free()


func increase(amount):
	health += amount
	if health >=max_health:
		health = max_health
