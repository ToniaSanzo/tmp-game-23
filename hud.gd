extends CanvasLayer

@export var player: Player
@onready var health_bar: ProgressBar = $TopHUD/HealthBar
@onready var score_label: Label = $TopHUD/ScoreLabel
@onready var high_score_label: Label = $TopHUD/HighScoreLabel
@onready var ammo_label: Label = $TopHUD/HealthBar/AmmoLabel

var high_score = 0
signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	player.hit.connect(update_health.bind(PlayerConstant.MAX_HEALTH))
	player.reload.connect(update_ammo.bind())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Arena"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_health(current_health: int, max_health: int):
	health_bar.value = current_health
	health_bar.max_value = max_health

func update_score(score):
	if score > high_score:
		high_score = score
		high_score_label.text = str("High Score: ", high_score)
	score_label.text = str(score)
	
func update_ammo(ammo):
	ammo_label.text = str("Ammo: ", ammo)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
