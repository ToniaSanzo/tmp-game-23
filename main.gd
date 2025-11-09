extends Node

@export var mob_scene: PackedScene
@export var health_loot: PackedScene
@export var ammo_loot: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LootTimer.stop()
	$HUD.show_game_over()

func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("health_loot", "queue_free")
	get_tree().call_group("ammo_loot", "queue_free")


func _on_mob_timer_timeout():
	
	for i in score / 15:
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instantiate()

		# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		
		mob_spawn_location.progress_ratio = randf()

		# Set the mob's position to the random location.
		mob.position = mob_spawn_location.position
		
		# Set the mob's direction perpendicular to the path direction.
		var direction = mob_spawn_location.rotation + PI / 2

		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)

		# Choose the velocity for the mob.
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		mob.linear_velocity = velocity.rotated(direction)
		#mob.AnimatedSprite2D.flip_h = mob.velocity.x >= 0

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)



func _on_start_timer_timeout():
	$MobTimer.start()
	$LootTimer.start()
	$ScoreTimer.start()


func _on_loot_timer_timeout() -> void:
	
	var rand = randf()
	var loot
	
	if rand < .5:
		# Create a new loot instance
		loot = health_loot.instantiate()
	else:
		loot = ammo_loot.instantiate()
		
	# Set a random loot location
	loot.position = Vector2(get_window().size.x * randf(), get_window().size.y * randf())

	# Add loot to the Main scene.
	add_child(loot)
