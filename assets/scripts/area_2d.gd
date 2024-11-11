extends Area2D

@export var hit_points: int = 1  # Number of hits before the object is destroyed
@export var base_score: int  # Score awarded on destruction
@export var push_back_force: float = 1000.0  # The force applied to push the player back
const SCORE_POPUP = preload("res://core/UI/score.tscn")
const PARTICLES = preload("res://entities/particuls.tscn")

# Called when a body enters the area, typically the player
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.bounce()
		# Calculate the direction to push the player back
		var collision_dir = (body.global_position - global_position).normalized()
		
		# Apply the push back force to the player's velocity
		body.velocity += collision_dir * push_back_force * get_process_delta_time()  # Scale force by delta time for frame rate independence

		# Reduce hit points
		hit_points -= 1
		
		# Display score popup
		var score_popup = SCORE_POPUP.instantiate()
		score_popup.score_value = base_score
		get_parent().add_child(score_popup)
		
		# Update global score and increase the score for the next hit
		Global.score += base_score
		base_score += 100
		
		# Check if hit points are depleted, then play particle effect and call kill function
		if hit_points <= 0:
			kill()

# Sets the 'killed' state for the parent node
func kill() -> void:
	get_parent().killed = true
