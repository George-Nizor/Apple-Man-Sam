class_name PowerUp extends Node

@export var player: Player
enum PowerUpType {SPEED, DAMAGE, HEALTH, NONE}
@export var type: PowerUpType

signal speedboost
signal damageboost
signal healthboost

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	match type:
		PowerUpType.SPEED:
			$Speed_Sprite.visible = true
		PowerUpType.DAMAGE:
			$Damage_Sprite.visible = true
		PowerUpType.HEALTH:
			$Health_Sprite.visible = true

# Function to call when the powerup collides with the player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		body.pick_up_power_up(self)
		match type:
			PowerUpType.SPEED:
				speedboost.emit()
			PowerUpType.DAMAGE:
				damageboost.emit()
			PowerUpType.HEALTH:
				healthboost.emit()
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
