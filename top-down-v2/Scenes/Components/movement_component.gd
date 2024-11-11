class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var moveSpeed: float = 100

#func _physics_process(delta: float) -> void:
#    var direction = get_movement_direction()
#    move_object(direction)

# This function calculates the direction based on input, 
# making it suitable for a player-controlled character.
func get_movement_direction() -> Vector2:
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x, y)

# Move the object in the given direction, making it reusable for any movement type.
func move_object(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		direction = direction.normalized()  # Normalize to ensure consistent speed
	if body:
		body.velocity = direction * moveSpeed
		body.move_and_slide()
