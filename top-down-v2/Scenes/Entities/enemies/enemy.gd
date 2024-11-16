extends CharacterBody2D

@onready var movement: MovementComponent = $enemy_movement
@onready var player: Player = get_parent().get_child(0)
@onready var animated_sprite = $AnimatedSprite2D
@export var attack_damage = 30
@onready var can_attack: bool = true
@onready var attack_cd: Timer = $attack_cd
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var making_path = true
@onready var path_timer: Timer = $Path_Timer


func _physics_process(delta: float) -> void:
	makepath()
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	movement.move_object(direction)
	if !velocity.is_zero_approx():
		animated_sprite.play("run")
	if player.global_position.x < global_position.x:
		animated_sprite.flip_h = true  # Flip sprite horizontally
	else:
		animated_sprite.flip_h = false  # Flip sprite horizontally
	#handle_rotation()
	#handle_animations()
	
func makepath() -> void:
	if making_path:
		nav_agent.target_position = player.global_position
		making_path = false
		path_timer.start()
		

func Enemy():
	pass
	
func Ememy3():
	pass

func _on_attack_cd_timeout() -> void:
	can_attack = true


func _on_attack_box_area_entered(area: Area2D) -> void:
	if area is Hitboxcomponent and can_attack == true:
		var hitbox : Hitboxcomponent = area
		if hitbox.get_parent().has_method("Player"):
			var attack = Attack.new()
			attack.damage = attack_damage
			hitbox.damage(attack)
			var sounds = get_tree().root.get_node('Test_Level/Player/Hit_Sounds').get_children()
			var random_sound = sounds[randi() % sounds.size()]
			random_sound.play()
			can_attack = false
			attack_cd.start()


func _on_path_timer_timeout() -> void:
	making_path = true
	
