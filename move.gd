extends Node
class_name MoveComponent

@export var speed: float = 200.0  # Speed of movement
@export var deceleration: float = 10.0  # Deceleration rate
@export var acceleration: float = 5.0  # Acceleration rate
@export var fall_on_turn: bool = false  # Enables ground-checking to prevent falling
var direction: int = 1  # Movement direction
@export var wall: RayCast2D  # RayCast2D for wall detection
@export var ground_check: RayCast2D  # RayCast2D for ground detection
@export var sprite: Node2D  # Sprite reference for flipping

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If there's no wall collision, move towards the target speed in the specified direction
	if not wall.is_colliding():
		get_parent().velocity.x = speed * -1 *direction
	else:
		turn()

	# If `fall_on_turn` is false, check if there's ground beneath
	if not fall_on_turn:
		if not ground_check.is_colliding():
			turn()

# Reverses the direction and updates the sprite flip
func turn() -> void:
	direction *= -1
	ground_check.target_position.x *= -1
	if  not fall_on_turn:
		wall.target_position *= -1  # Flip the wall check position
	sprite.flip_h = direction > 0  # Flip the sprite visually
	get_parent().velocity.x = 0  # Stop movement momentarily after turning
