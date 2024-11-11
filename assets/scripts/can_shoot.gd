extends Node2D

@export var bullet: PackedScene # The bullet scene to instantiate
@export var marker:Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optionally, you can initialize things here
	position=marker.position


# Function to instantiate and shoot a bullet
func shoot() -> void:
	position=marker.position
	get_parent().shoot = true
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = marker.global_position
	add_child(bullet_instance)



func _on_timer_timeout() -> void:
	shoot()
