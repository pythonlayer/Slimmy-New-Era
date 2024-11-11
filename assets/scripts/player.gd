extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $sprite

# State variables
var is_jumping = false
var is_looking_up = false
var is_looking_down = false

# Jump and movement parameters
var base_jump_speed = 255.0
var jump_speed_incr = 8.375
var gravity_normal = 1400.0
var gravity_a_pressed = 675.0
var acceleration = 337.5
var walk_decel = 562.0
var run_decel = 1125.0
var p_meter_starting_speed = 131.0
var max_speed = 75.0

# Constants for max speeds
const MAX_WALK = 75.0
const MAX_RUN = 135.0
const MAX_SPRINT = 200.0

# P-meter for sprint buildup
var p_meter = 0.0

# Animation constants
const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"
const ANIM_RUN = "run"
const ANIM_JUMP = "jump"
const ANIM_LOOK_UP = "look_up"
const ANIM_LOOK_DOWN = "look_down"
var played :bool = true
# Timers for jump assistance
@onready var rodeo: Timer = $rodeo
@onready var help: Timer = $help

func _physics_process(delta: float) -> void:
	if !is_jumping and !is_on_floor():
		help.start()
	handle_movement(delta)
	apply_gravity(delta)
	update_animation()

func handle_movement(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	
	# Disable left-right movement if looking up or down
	if !is_looking_down:
		handle_walking(delta, direction)

	if Input.is_action_just_pressed("A") and !is_jumping:
		velocity.y = jump()
		is_jumping = true

	move_and_slide()

	if is_on_floor():
		is_jumping = false

	if direction != 0:
		sprite.flip_h = direction < 0

	handle_look_up_down()

func handle_walking(delta: float, direction: float) -> void:
	update_p_meter()

	max_speed = get_max_speed()
	var accel = base_accel()
	var decel = base_decel()
	
	if !is_on_floor() and direction == 0:
		return 
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * max_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)

func get_max_speed() -> float:
	var end_speed = max_speed
	if p_meter >= 70.0:
		end_speed = MAX_SPRINT
	else:
		end_speed = MAX_RUN if Input.is_action_pressed("B") else MAX_WALK
	var slopiness = round(sin(get_floor_angle()) * 10) / 10
	if is_on_floor() and get_floor_angle() != 0: # Check if floor angle is not flat.
		if get_real_velocity().y < 0: # Moving up
			end_speed -= end_speed * slopiness
		else: # Moving down
			end_speed += end_speed * slopiness
	
	return end_speed

func update_p_meter() -> void:
	if Input.is_action_pressed("B"):
		p_meter = clamp(p_meter + 1, 0, 70)  
	else:
		p_meter = clamp(p_meter - 1, 0, 70)  

func base_accel() -> float:
	var end_acc = acceleration
	var slopiness = round(sin(get_floor_angle()) * 10) / 10
	if is_on_floor() and get_floor_angle() != 0: # Check if floor angle is not flat.
		if get_real_velocity().y < 0: # Moving up
			end_acc -= end_acc * slopiness
		else: # Moving down
			end_acc += end_acc * slopiness
	return end_acc

func base_decel() -> float:
	var end_decel = 0 
	if max_speed > MAX_WALK:
		end_decel = run_decel
	else:
		end_decel = walk_decel

	var slopiness = round(sin(get_floor_angle()) * 10) / 10
	if is_on_floor() and get_floor_angle() != 0: # Check if floor angle is not flat.
		if get_real_velocity().y < 0: # Moving up
			end_decel += end_decel * slopiness
		else:
			end_decel -= end_decel * slopiness * 0.5 # Decelerate slower while descending

	return end_decel

func jump() -> float:
	var base_speed = base_jump_speed
	var speed_incr = jump_speed_incr
	return -(base_speed + speed_incr * int(velocity.x) / 30)

func apply_gravity(delta: float) -> void:
	var current_gravity = gravity_normal
	if Input.is_action_pressed("A"):
		current_gravity = gravity_a_pressed
	if velocity.y > 0:
		current_gravity*=1.5
	if !is_on_floor():
		velocity.y += current_gravity * delta
	elif velocity.y > 0:
		velocity.y = 0

func update_animation() -> void:
	if !is_jumping:
		played=false
	if is_jumping:
		if !played:
			$sound.play()
			
			played = true
		sprite.play(ANIM_JUMP)
	elif abs(velocity.x) > 0:
		if abs(velocity.x) > 75:
			sprite.play(ANIM_RUN)
		else:
			sprite.play(ANIM_WALK)
	elif is_looking_up:
		sprite.play(ANIM_LOOK_UP)
	elif is_looking_down:
		sprite.play(ANIM_LOOK_DOWN)
	else:
		sprite.play(ANIM_IDLE)

func handle_look_up_down() -> void:
	is_looking_up = Input.is_action_pressed("up") and velocity == Vector2(0,0)
	is_looking_down = Input.is_action_pressed("down") and velocity == Vector2(0,0)

	if is_looking_up:
		sprite.play(ANIM_LOOK_UP)
	elif is_looking_down:
		sprite.play(ANIM_LOOK_DOWN)

func _on_animation_finished(anim_name: String) -> void:
	# Only stop animations for look up and look down
	if anim_name == ANIM_LOOK_UP and is_looking_up:
		sprite.stop()
	elif anim_name == ANIM_LOOK_DOWN and is_looking_down:
		sprite.stop()

func bounce() -> void:
	# Check if "U" is held for a higher bounce
	var bounce_strength = base_jump_speed
	if Input.is_action_pressed("A"):
		bounce_strength = base_jump_speed * 1.25
	else:
		bounce_strength = 0.5 * base_jump_speed
	is_jumping = true
	velocity.y = -max(abs(bounce_strength),-velocity.y)
	sprite.play("jump")

func _on_rodeo_timeout() -> void:
	pass # Replace with function body.

func _on_help_timeout() -> void:
	is_jumping = true
