extends CharacterBody2D

const JUMP_VELOCITY = -250.0
var killed: bool = false
var shoot: bool = false
const BULLET = preload("res://entities/bullet.tscn")
# Adjust this variable based on how frequently the enemy should shoot
@export var shoot_delay: float = 1.0
var shoot_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y+=800*delta
	if Input.is_action_pressed("A") and is_on_floor():
		jump()
	update_animation()
	move_and_slide()

func jump() -> void:
	velocity.y = JUMP_VELOCITY

func update_animation() -> void:
	if killed:
		$animator.play("die")
	else:
		if !is_on_floor():
			$animator.play("jump")
		else:
			if shoot:
				$animator.play("shoot")
			else:
				$animator.play("idle")
func shoot_bullet():
	# Logic to shoot a bullet
	var bullet_instance = BULLET.instantiate()
	bullet_instance.position = global_position # Or wherever you want it to start
	$GunPoint.add_child(bullet_instance)
