extends Node
@export var fruit_scene: PackedScene

var score = 0
var previous_limit = 0
var level = 1
var missed = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuMusic.play()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fruit_timer_timeout() -> void:
	var fruit = fruit_scene.instantiate()
	var fruit_spawn = $FruitPath/FruitSpawnLocation
	fruit_spawn.progress_ratio = randf()
	fruit.position = fruit_spawn.position

	# Use formulas for gravity and timer wait time instead of if/else
	fruit.gravity_scale = 0.2 + (0.1 * level)  # Increases gravity scale with level
	$FruitTimer.wait_time = max(0.5, 1.0 - (0.01 * level))  # Decreases wait time with level but capped at 0.5 seconds

	# If the level is more than 100, make fruits fall in random directions
	if score >= 20:
		# Apply a random rotation
		fruit.rotation_degrees = randi_range(0, 360)  # Random initial rotation

		# Apply random velocity to make the fruit move in random directions
		var bound_x = -150
		var bound_y = 150
		var ybound_x = 100
		var ybound_y = 300
		if score >= 50:
			bound_x += 50
			bound_y += 50
			ybound_x += 50
			ybound_y += 50
		elif score >= 100:
			bound_x += 100
			bound_y += 100
			ybound_x += 50
			ybound_y += 50
		var random_velocity_x = randi_range(bound_x, bound_y)  # Random horizontal velocity
		var random_velocity_y = randi_range(ybound_x, ybound_y)  # Random vertical velocity (to simulate falling)
		fruit.linear_velocity = Vector2(random_velocity_x, random_velocity_y)
	else:
		# Ensure fruits fall straight down at lower levels
		fruit.linear_velocity = Vector2(0, 300)  # Straight down

	print('Spawning fruit!\nGravity: %s\nDelay: %s' % [fruit.gravity_scale, $FruitTimer.wait_time])
	add_child(fruit)
	move_child(fruit, 5)
	

#func _on_fruit_timer_timeout() -> void:
	#var fruit = fruit_scene.instantiate()
	#var fruit_spawn = $FruitPath/FruitSpawnLocation
	#fruit_spawn.progress_ratio = randf()
	#fruit.position = fruit_spawn.position
#
	## Use formulas for gravity and timer wait time instead of if/else
	#fruit.gravity_scale = 0.2 + (0.1 * level)  # Increases gravity scale with level
	#$FruitTimer.wait_time = max(0.5, 1.0 - (0.01 * level))  # Decreases wait time with level but capped at 0.5 seconds
#
	#print('Spawning fruit!\nGravity: %s\nDelay: %s' % [fruit.gravity_scale, $FruitTimer.wait_time])
	#add_child(fruit)

func _on_basket_catched() -> void:
	score += 1
	$HUD.update_score(score, missed)

	if score % 10 == 0 and previous_limit != score:
		previous_limit = score
		level += 1
		var faster_messages = [
	"It's getting faster!",
	"Speeding up!",
	"Hold on, it's getting quicker!",
	"Faster and faster!",
	"Things are speeding up!",
	"Hang tight, it's getting fast!",
	"Faster. Faster. Faster!",
	"So fast, it's faster than Flash!",
	"We're hitting light speed!",
	"Going turbo mode!",
	"You're catching up to Sonic!",
	"Faster than Goku charging up!",
	"Hold tight, we're breaking the sound barrier!",
	"You're faster than the Millennium Falcon!",
	"It's like we're in a Fast & Furious race!",
	"Going Super Saiyan speed!",
	"You're moving like the Flash in Speed Force!",
	"Get ready for ludicrous speed!",
	"Woah, it's like a race in Mario Kart now!",
	"Zooming like a podracer on Tatooine!",
	"You're faster than Usain Bolt!",
	"Like Naruto running with full power!",
	"We're in overdrive now!",
	"Going as fast as a Quidditch snitch!",
	"Lightning fast, like Pikachu's Thunderbolt!",
	"Moving like Dash from The Incredibles!",
	"You're moving faster than Neo dodging bullets!",
	"You're speeding like the DeLorean in Back to the Future!",
	"It's like you're in hyperdrive!",
	"This is like Gran Turismo on max speed!",
	"You're zipping like Speed Racer!",
	"On the move like the Batmobile!",
	"Moving faster than the TARDIS!",
	"This is anime-level speed!",
	"You're moving at warp speed, Captain!",
	"Full throttle like Mad Max!",
	"Fast as lightning—Thor would be jealous!",
	"You're faster than a bullet train!",
	"Channeling the speed of Hermes!",
	"Going faster than light—Einstein is shook!",
	"You’ve gone plaid!",
	"It's like you hit NOS in a race!",
	"Faster than a speeding bullet!",
	"Like a supersonic jet!"
]


		# To choose a random message:
		var random_message = faster_messages[randi() % faster_messages.size()]
		$HUD.show_message(random_message)
		await get_tree().create_timer(1.0).timeout
		print('LEVEL UP! NEW LEVEL: %s' % level)

	
func start_game():
	score = 0
	missed = 0
	$HUD.update_score(score, missed)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("fruits", "queue_free")
	$Basket.start($StartPosition.position)
	$FruitTimer.start()
	$MenuMusic.stop()
	$Music.play()
	
func game_over():
	$FruitTimer.stop()
	$HUD.show_game_over(score)
	score = 0
	missed = 0
	previous_limit = 0
	level = 0
	$Music.stop()
	$GameOver.play()
	$Basket.hide()
	$Basket/CollisionShape2D.set_deferred("disabled", true)
	$MenuMusic.play()
	
		


func _on_ground_body_entered(body: Node2D) -> void:
	missed += 1
	$HUD.update_score(score, missed)
	if missed >= 5:
		game_over()
