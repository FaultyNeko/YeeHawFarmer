extends "res://Scripts/Enemies/EnemyBase.gd"

@export var shoot_range: float = 200.0
@export var fire_rate: float = 1.0
@export var projectile_scene: PackedScene
var time_since_last_shot: float = 0.0
var player: Node2D

func _ready() -> void:
	super._ready()
	var players = get_tree().get_nodes_in_group("Player")
	player = players[0] if players.size() > 0 else null

func _process(delta: float) -> void:
	if is_dead or player == null:
		return

	time_since_last_shot += delta
	var distance_to_player = global_position.distance_to(player.global_position)

	# Ranged behavior: Move if needed, or stay put and shoot
	if distance_to_player <= shoot_range:
		# Optionally move to maintain distance or line of sight
		ranged_movement(delta)
		if time_since_last_shot >= 1.0 / fire_rate:
			shoot_projectile()
			time_since_last_shot = 0.0
	else:
		# Player too far: maybe move closer or patrol
		idle_behavior(delta)

func ranged_movement(delta: float) -> void:
	# Example: This enemy stands still when player in range.
	# Could also add logic to strafe or maintain optimal distance.
	velocity = Vector2.ZERO
	move_and_slide()

func shoot_projectile() -> void:
	if not projectile_scene:
		return
	var bullet = projectile_scene.instantiate()
	bullet.position = global_position
	# Aim at player
	var direction = (player.global_position - global_position).normalized()
	# Suppose bullet has a 'velocity' variable we can set
	bullet.velocity = direction * 300.0 # Example speed
	get_parent().add_child(bullet)

func idle_behavior(delta: float) -> void:
	# Maybe roam around
	velocity = Vector2.ZERO
	move_and_slide()
