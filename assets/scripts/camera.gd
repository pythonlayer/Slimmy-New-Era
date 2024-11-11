extends Camera2D

var is_paused = false

@export_category("Initial Parameters")
@export var MIN_OFFSET_X = -125.0
@export var MAX_OFFSET_X = 75.0
@export var MIN_OFFSET_Y = -50.0
@export var MAX_OFFSET_Y = 50.0
@export var FORWARD_OFFSET_X = 50.0
@export_category("Following")
@export var player: CharacterBody2D

var up_hold_time = 0.0
var down_hold_time = 0.0
const HOLD_THRESHOLD = 0.5
const OFFSET_LERP_SPEED = 0.1
const RESET_LERP_SPEED = 0.2

func _process(delta: float) -> void:
	position = player.position
	handle_camera_movement(delta)

func handle_camera_movement(delta: float) -> void:
	handle_horizontal_movement()
	handle_vertical_movement(delta)

func handle_horizontal_movement() -> void:
	if Input.is_action_pressed("L"):
		offset.x = lerp(offset.x, -FORWARD_OFFSET_X, OFFSET_LERP_SPEED)
		if player.velocity.x > 0:
			offset.x = lerp(offset.x, 0.0, RESET_LERP_SPEED)
	elif Input.is_action_pressed("R"):
		offset.x = lerp(offset.x, FORWARD_OFFSET_X, OFFSET_LERP_SPEED)
		if player.velocity.x < 0:
			offset.x = lerp(offset.x, 0.0, RESET_LERP_SPEED)
	else:
		offset.x = lerp(offset.x, 0.0, OFFSET_LERP_SPEED)

func handle_vertical_movement(delta: float) -> void:
	# Handle up offset with hold threshold
	if Input.is_action_pressed("up"):
		up_hold_time += delta
		if up_hold_time >= HOLD_THRESHOLD:
			offset.y = lerp(offset.y, MIN_OFFSET_Y, OFFSET_LERP_SPEED)
	else:
		up_hold_time = 0.0

	# Handle down offset with hold threshold
	if Input.is_action_pressed("down"):
		down_hold_time += delta
		if down_hold_time >= HOLD_THRESHOLD:
			offset.y = lerp(offset.y, MAX_OFFSET_Y, OFFSET_LERP_SPEED)
	else:
		down_hold_time = 0.0

	# Reset y offset if neither up nor down are pressed
	if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
		offset.y = lerp(offset.y, 0.0, OFFSET_LERP_SPEED)
