extends Node2D
@onready var puff_out: CPUParticles2D = $"Puff out"

func _ready() -> void:
	set_as_top_level(true)
	puff_out.emitting = true


func _on_puff_out_finished() -> void:
	queue_free()
