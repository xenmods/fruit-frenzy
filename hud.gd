extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(catched):
	show_message("Game Over!\nYou catched: %s fruits." % catched)
	
	await $MessageTimer.timeout
	$Score.hide()
	$GameTitle.show()
	$Author.show()
	$Message.text = "Catch the fruits! You lose on 5 misses."
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(catched, missed):
	$Score.text = "Catched: %s\nMissed: %s" % [catched, missed]


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Score.show()
	$GameTitle.hide()
	$Author.hide()
	start_game.emit()
