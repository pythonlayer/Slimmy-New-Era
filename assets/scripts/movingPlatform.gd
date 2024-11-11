extends PathFollow2D

@export var speed: float = 5.0
@export var moving: bool = true  # Toggle to start/stop movement

# Variable to keep track of direction
var moving_forward: bool = true
func _ready() -> void:
	$TileMapLayer.use_kinematic_bodies = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Only move if the moving flag is set to true
	if moving:
		# Update the progress_ratio along the path based on speed and delta time
		progress_ratio += speed*0.1 * delta * (1 if moving_forward else -1)

		# Optional: Loop the progress_ratio to stay within bounds [0, 1]
		if progress_ratio > 1.0:
			progress_ratio = 0.0  # Reset to start
		elif progress_ratio < 0.0:
			progress_ratio = 1.0  # Wrap to end
