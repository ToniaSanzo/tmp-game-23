extends Area2D
class_name Player

signal hit(remaining_health: int)
signal die
@export var speed = 400
@export var bullet : PackedScene
var screen_size
var shooting
var remaining_health := PlayerConstant.MAX_HEALTH
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.z_index = 9
	hide()
	$AnimatedSprite2D.animation = "idle"
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	#if Input.is_action_pressed("shoot"):
		#shoot()
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x >= 0
	else:
		$AnimatedSprite2D.animation = "idle"

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# event.position is the click position in viewport coordinates (top-left origin).
		# Perfect for most 2D uses like spawning objects or raycasting.
		
		var angle = (event.position - position).angle()
		shoot(angle)
		# Example: Move a sprite to the click position
		
		
		# For global canvas coordinates (ignores some transforms):
		# var global_pos = get_global_mouse_position()

func shoot(angle):
	var b = bullet.instantiate()
	b.setup(angle)
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	$Gunshot.play()
	
func start(pos):
	remaining_health = PlayerConstant.MAX_HEALTH
	hit.emit(remaining_health)
	
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	if body.is_in_group("loot"):
		print("healing")
		if remaining_health < PlayerConstant.MAX_HEALTH:
			remaining_health += 20
			hit.emit(remaining_health)
			body.queue_free()
		return
	
	remaining_health -= 20
	hit.emit(remaining_health)
	
	
	if remaining_health <= 0:
		die.emit()
		hide() # Player disappears after being hit.
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
