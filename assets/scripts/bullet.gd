extends CharacterBody2D

var SPEED = 250.0  # Speed of the character

# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	set_as_top_level(true)
	global_position.x -=SPEED*delta
