extends "res://Scripts/Enemies/EnemyBase.gd"

@export var chase_range: float = 100.0
@export var attack_range: float = 20.0
@export var attack_cooldown: float = 1.5
var time_since_last_attack: float = 0.0

var player: Node2D

func _ready() -> void:
	# Call the parent ready if needed: super call in Godot 4:
	super._ready()
	# Find the player or set up references. Assuming player is in a group.
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		print("Player found:", player)
	else:
		print("No player found in group 'Player'")


func _process(delta: float) -> void:
	if is_dead or player == null:
		return

	time_since_last_attack += delta
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= chase_range:
		# Move towards player
		move_towards_player(delta)
		
		# If close enough, try attack
		if distance_to_player <= attack_range and time_since_last_attack >= attack_cooldown:
			perform_melee_attack()
			time_since_last_attack = 0.0
	else:
		# Idle or patrol logic if needed
		idle_behavior(delta)

func move_towards_player(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func perform_melee_attack() -> void:
	# Simple melee attack: directly deal damage to the player if in range
	# The player must have a 'take_damage' method or similar
	if player and global_position.distance_to(player.global_position) <= attack_range:
		player.call("take_damage", atk)

func idle_behavior(delta: float) -> void:
	# Default idle behavior: stand still or patrol
	velocity = Vector2.ZERO
	move_and_slide()
