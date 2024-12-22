extends "res://Scripts/Enemies/MeleeEnemy.gd"

func _ready() -> void:
	super._ready()
	hp = 20
	atk = 5
	speed = 100.0
	chase_range = 120.0
	attack_range = 15.0
	attack_cooldown = 2.0

	# If you need unique behavior: override or add methods here
	# For now, it just uses the MeleeEnemy behavior as is.
