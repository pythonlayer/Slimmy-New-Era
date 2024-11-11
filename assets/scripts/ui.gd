extends CanvasLayer

@onready var time: Label = $CanvasLayer/time
@onready var lives: Label = $CanvasLayer/lives
@onready var score: Label = $CanvasLayer/score

# Initialize variables to store time, lives, and score
var current_time: int = 200
var current_lives: int = 3  # Start with 3 lives or set as needed
var current_score: int = 0  # Start at 0 score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Decrease time each frame (optional)
	current_score = Global.score
	update_ui()

# Function to update the UI labels
func update_ui() -> void:
	# Update the time label (convert to seconds and format)
	time.text = "TIME\n " + str(int(current_time))
	
	# Update the lives label
	lives.text = "x " + str(current_lives)
	
	# Update the score label with leading zeros (0000 format)
	score.text = str(current_score).pad_zeros(4)

# Function to modify lives (to be called from your game logic)
func set_lives(life_count: int) -> void:
	current_lives = life_count
	update_ui()

# Function to increase time (for demonstration purposes)
func add_time() -> void:
	current_time -= 1
	current_time = max(current_time,0)
	update_ui()


func add_score(amount: int) -> void:
	current_score += amount
	update_ui()
