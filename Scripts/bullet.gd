extends Area2D

@export var damage: int = 10
@export var lifespan: float = 2.0  # seconds
var velocity: Vector2 = Vector2.ZERO  # Define velocity as a class variable

func _ready() -> void:
	# Connect the area_entered signal using Callable
	connect("area_entered", Callable(self, "_on_Bullet_area_entered"))

func _process(delta: float) -> void:
	position += velocity * delta
	lifespan -= delta
	if lifespan <= 0:
		queue_free()

func _on_Bullet_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.call("take_damage", damage)
		queue_free()
	elif area.is_in_group("Environment"):
		queue_free()
