extends Camera2D

const Dead_Zone = 200
const Max_Camera_Move = 100  # Maximum distance the camera can move from the center
var shake_intensity = 5.0  # Max offset in pixels
var shake_duration = 0.5  # Shake time in seconds
var shake_timer = 0.0  # Timer to track shake duration
@export var player: Player



func _ready() -> void:
	# Connect to the signal from the unrelated script
	var signal_source = player.health.took_damage.connect(shake) # Update this path
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		
		# If the mouse is within the dead zone, don't move the camera
		if _target.length() < Dead_Zone:
			self.position = Vector2(0, 0)
		else:
			# Calculate the desired camera position
			var desired_position = _target.normalized() * (_target.length() - Dead_Zone) * 0.5
			
			# Clamp the camera position by limiting the x and y components
			self.position.x = clamp(desired_position.x, -Max_Camera_Move, Max_Camera_Move)
			self.position.y = clamp(desired_position.y, -Max_Camera_Move, Max_Camera_Move)
			
			
func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
	# Apply a small random offset to the camera's position each frame
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		# Reset offset when shake ends
		offset = Vector2.ZERO

func shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = shake_duration
