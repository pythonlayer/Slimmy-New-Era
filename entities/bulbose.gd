extends CharacterBody2D
const PARTICULS = preload("res://entities/particuls.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var killed:bool = false
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y+=800*delta
	if !killed:
		move_and_slide()
		if abs(velocity.x) > 0:
			pass
			animation_player.play("walk",-1,0.5)
	else:
		animation_player.play("die")
		await animation_player.animation_finished
		var smoke_effect = PARTICULS.instantiate()
		smoke_effect.position = position
		add_child(smoke_effect)
		queue_free()
