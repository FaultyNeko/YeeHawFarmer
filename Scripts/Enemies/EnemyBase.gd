extends CharacterBody2D

@export var hp: int = 0
@export var atk: int = 0
@export var speed: float = 0.0

var is_dead: bool = false

func _ready() -> void:
	# You might do general initialization for all enemies here.
	# Child classes can override _ready() and call ._ready() on super if needed.
	pass

func take_damage(damage: int) -> void:
	if is_dead:
		return

	hp -= damage
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true
	# Handle death logic: play animation, drop loot, queue_free(), etc.
	queue_free()

func _process(delta: float) -> void:
	if is_dead:
		return
	# Generic logic that all enemies might need, or leave empty.
