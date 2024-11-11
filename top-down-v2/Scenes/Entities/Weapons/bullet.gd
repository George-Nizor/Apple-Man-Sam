extends CharacterBody2D

@onready var player: Player = get_tree().get_root().get_node("Test_Level/Player")
@export var speed = 300
var attack_damage
var projectile_direction
var has_hit_enemy := false


func _ready():
	$Timer.start(1)

func _process(delta: float) -> void:
	position -= projectile_direction * speed * delta
	pass

func _on_timer_timeout() -> void:
	queue_free()
	
	
func projectile():
	pass


func _on_area_2d_area_entered(area:Area2D) -> void:
	if has_hit_enemy:
		return
		
	if area is Hitboxcomponent:
		has_hit_enemy = true
		var hitbox : Hitboxcomponent = area
		var attack = Attack.new()
		attack.damage = player.current_damage
		hitbox.damage(attack)
		self.hide()
		$hit_sound.play()
		await $hit_sound.finished
		queue_free()
