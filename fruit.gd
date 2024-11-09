extends Node

var chosen_fruit # the chosen fruit
var screen_size = Vector2()
var fruit_size  # Size of the player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size 
	print(screen_size)
	#var fruits = [$banana, $"red-cherry", $lemon, $peach, $watermelon]
	var fruits = [$banana, $lemon, $peach, $"red-cherry", $watermelon]
	for fruit in fruits:
		fruit.hide()
	chosen_fruit = fruits[randi() % fruits.size()]
	chosen_fruit.show()
	fruit_size = chosen_fruit.shape.get_rect().size
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
