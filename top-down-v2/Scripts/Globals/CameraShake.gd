# CameraShake.gd
extends Camera2D

var shake_intensity = 5.0  # Max offset in pixels
var shake_duration = 0.5  # Shake time in seconds
var shake_timer = 0.0  # Timer to track shake duration

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
