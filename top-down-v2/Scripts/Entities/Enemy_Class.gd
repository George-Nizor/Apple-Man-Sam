class_name EnemyClass extends CharacterBody2D

enum enemy_movement_type {RUN, DASH}
@export var target_player: Player
@export var sprite: AnimatedSprite2D
@export var can_attack: bool
@export var attack_damage: int
@export var health_bar: ProgressBar
@export var health_node: Healthcomponent
@export var attack_cooldown: Timer
@export var attack_box: Area2D # Add a reference to the attack_box
@export var movement_type: enemy_movement_type
var making_path: bool = true
@export var nav_agent: NavigationAgent2D
@export var path_timer: Timer
@export var movement: MovementComponent
@export var dash_speed: int
var dashing = false  # Tracks if the enemy is currently dashing
@export var dash_duration: float 
var original_rotation: float

func _ready() -> void:
    original_rotation = rotation
    setup_attack_box()
    setup_attack_cd()

# Setup function to connect the signal
func setup_attack_box() -> void:
    if attack_box:
        # Use Callable to reference the method
        attack_box.connect("area_entered", Callable(self, "_on_attack_box_area_entered"))

func setup_attack_cd() -> void:
    if attack_cooldown:
        attack_cooldown.connect("timeout",Callable(self,"_on_attack_cd_timeout"))

func _on_attack_cd_timeout() -> void:
    can_attack = true

# damage player function
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
            attack_cooldown.start()


func regular_movement():
    makepath()
    var direction = to_local(nav_agent.get_next_path_position()).normalized()
    movement.move_object(direction)
    if !velocity.is_zero_approx():
        sprite.play("run")
    if target_player.global_position.x < global_position.x:
        sprite.flip_h = true  # Flip sprite horizontally
    else:
        target_player.flip_h = false  # Flip sprite horizontally
    health_bar.value = health_node.health


func makepath() -> void:
    if making_path:
        nav_agent.target_position = target_player.global_position
        making_path = false
        path_timer.start()

func dash_toward_player():
    # Get direction to player, set velocity, and start dashing
    var player_position = target_player.global_position
    var direction = (player_position - global_position).normalized()
    velocity = dash_speed * direction
    dashing = true
    if player_position.x < global_position.x:
        sprite.flip_h = true  # Flip sprite horizontally
        sprite.flip_v = true  # Flip sprite vertically
    else:
        sprite.flip_h = false  # Reset flip
    look_at(player_position)

    # Schedule stop to end the dash after dash_duration
    await get_tree().create_timer(dash_duration).timeout
    stop_dash()

func stop_dash():
    velocity = Vector2.ZERO  # Clear velocity to stop movement
    rotation = original_rotation
    sprite.flip_v = false  # Rest vertical flip
    dashing = false  # End dashing state

# Timer callback to initiate the dash
func _on_dash_timer_timeout() -> void:
    dash_toward_player()