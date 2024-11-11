extends AnimatableBody2D

@export var score_value: int = 100          # Set score value from the enemy
@export var rise_speed: float = 100.0       # Initial speed at which score rises
@export var fade_duration: float = 1.5      # Time in seconds for the score to fade out
@onready var label: Label = $Label

var fade_timer: float = 0.0                 # Timer to control the fade-out effect

# Initialize the score display and position
func _ready() -> void:
	label.text = str(score_value)
	set_position(Vector2(position.x, position.y))  # Set initial position

# Update the score's position, speed, and fade-out effect
func _process(delta: float) -> void:
	# Decrease rise speed based on height to slow down the score rise
	var slow_factor = clamp(position.y / 200.0, 0.3, 1.0)  # Adjust divisor for desired effect
	position.y -= rise_speed * delta * slow_factor
	
	# Fade-out effect
	fade_timer += delta
	if fade_timer >= fade_duration:
		queue_free()  # Remove the score label when the fade is complete
	else:
		# Gradually reduce the opacity
		modulate.a = lerp(1.0, 0.0, fade_timer / fade_duration)

# Method to set score from enemy
func set_score(value: int) -> void:
	score_value = value
	label.text = str(score_value)
