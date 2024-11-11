extends  CharacterBody2D



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"../AnimationPlayer".play("animated")
