extends CharacterBody2D
const PARTICULS = preload("res://entities/particuls.tscn")
@export var sprite: AnimatedSprite2D

var killed:bool = false
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y+=800*delta
	if !killed:
		move_and_slide()
		if abs(velocity.x) > 0:
			sprite.play("walk")
		else:
			sprite.play("turn")
	else:
		sprite.play("die")
		await sprite.animation_finished
		var smoke_effect = PARTICULS.instantiate()
		smoke_effect.position = position
		add_child(smoke_effect)
		queue_free()
