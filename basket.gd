extends Area2D

signal catched

# Declare player variables
var speed = 300  # Speed of player movement
var screen_size = Vector2()
var player_size  # Size of the player

func _ready():
	screen_size = get_viewport_rect().size  # Get screen size
	player_size = $CollisionShape2D.shape.get_rect().size
	position.y = screen_size.y - 50  # Start at the bottom of the screen
	hide()

func _process(delta):
	# Clamp the player's position within the screen bounds to prevent clipping
	position.x = clamp(position.x, player_size.x / 2, screen_size.x - player_size.x / 2)

func _input(event):
	# Detect drag on both touch devices (InputEventScreenDrag) and desktop (InputEventMouseMotion)
	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		# Move the player horizontally based on the drag event
		position.x += event.relative.x

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	catched.emit()
	body.queue_free()
	$CatchSound.play()
