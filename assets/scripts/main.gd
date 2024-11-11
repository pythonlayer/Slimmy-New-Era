extends Node

# Variable to control the pause state
var is_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check for the "start" action
	if Input.is_action_just_pressed("start"):  # Replace with your pause key
		toggle_pause()  # Toggle the pause state

	# Optional: Show a pause menu if needed
	if is_paused:
		show_pause_menu()  # Implement this function if you have a pause menu

func toggle_pause() -> void:
	is_paused = !is_paused  # Toggle the pause state
	get_tree().paused = is_paused  # Set the tree paused state

	# You can also show/hide UI elements or pause music here
	if is_paused:
		# Optional: Show pause menu or UI
		print("Game Paused")
	else:
		# Optional: Hide pause menu or UI
		print("Game Resumed")

func show_pause_menu() -> void:
	# Implement your pause menu UI logic here
	# Example: Show a UI overlay that prevents interaction with the game
	pass
