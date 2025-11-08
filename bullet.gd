extends Area2D

@export var speed = 3000
var direction : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = PI / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = 1500
	position += direction * speed * delta

func setup(angle: float):
	
	direction = Vector2(cos(-angle), sin(angle))
	$Sprite2D.rotation = direction.angle()
	$CollisionShape2D.position = direction
	#rotation = anglea
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
