extends Node

@export var gravity:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_parent().is_on_floor():
		get_parent().velocity.y += gravity
