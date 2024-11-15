extends CharacterBody2D

@onready var player: Player = get_parent().get_child(0)
@onready var dash_timer: Timer = $dash_timer  # Timer to control dash intervals
var dashing = false  # Tracks if the enemy is currently dashing
var dash_speed = 250  # Speed of the dash
var dash_duration = 0.3  # Duration of each dash in seconds
@onready var original_rotation = rotation
@onready var enemy_2_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cd: Timer = $attack_cd
@onready var can_attack = true
@export var attack_damage = 30

func _ready() -> void:
	dash_timer.start() 

func _physics_process(delta: float) -> void:
	if dashing:
		# Move in the set direction while dashing is active
		move_and_slide()

func dash_toward_player():
	# Get direction to player, set velocity, and start dashing
	var player_position = player.global_position
	var direction = (player_position - global_position).normalized()
	velocity = dash_speed * direction
	dashing = true
	if player_position.x < global_position.x:
		enemy_2_sprite.flip_h = true  # Flip sprite horizontally
		enemy_2_sprite.flip_v = true  # Flip sprite vertically
	else:
		enemy_2_sprite.flip_h = false  # Reset flip
	look_at(player_position)
	
	# Schedule stop to end the dash after dash_duration
	await get_tree().create_timer(dash_duration).timeout
	stop_dash()

func stop_dash():
	velocity = Vector2.ZERO  # Clear velocity to stop movement
	rotation = original_rotation
	enemy_2_sprite.flip_v = false  # Rest vertical flip
	dashing = false  # End dashing state

# Timer callback to initiate the dash
func _on_dash_timer_timeout() -> void:
	dash_toward_player()


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


func _on_attack_cd_timeout() -> void:
	can_attack = true
	
func Enemy():
	pass
func Enemy2():
	pass
