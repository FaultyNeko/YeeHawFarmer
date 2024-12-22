extends CharacterBody2D
@export var fire_rate: float = 2.0  # Bullets per second
var time_since_last_shot: float = 0.0
@export var bullet_scene: PackedScene = preload("res://Scenes/Bullet.tscn")
@export var bullet_speed: float = 400.0
@export var num_bullets: int = 5
@export var spread_angle: float = 45.0  # degrees
var is_immune: bool = false

var ability_active: bool = false
var ability_duration: float = 5.0  # seconds
var ability_cooldown: float = 10.0  # seconds
var ability_time_remaining: float = 0.0
var cooldown_time_remaining: float = 0.0

var health: int = 100




@export var speed: float = 200.0  # Adjust as needed

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	velocity = velocity.normalized() * speed

	move_and_slide()
	
	look_at(get_global_mouse_position())
	
func _process(delta: float) -> void:
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot >= 1.0 / fire_rate:
		shoot()
		time_since_last_shot = 0.0

	# Handle the special ability
	handle_ability(delta)
	
func shoot() -> void:
	var angle_between_bullets = spread_angle / max(num_bullets - 1, 1)
	var start_angle = -spread_angle / 2
	var muzzle_position = $Muzzle.global_position

	for i in range(num_bullets):
		var bullet_instance = bullet_scene.instantiate()
		var bullet_angle = deg_to_rad(start_angle + angle_between_bullets * i)
		var direction = Vector2.RIGHT.rotated(rotation + bullet_angle)

		bullet_instance.position = muzzle_position
		bullet_instance.rotation = direction.angle()
		bullet_instance.set("velocity", direction * bullet_speed)

		get_parent().add_child(bullet_instance)


func handle_ability(delta: float) -> void:
	if ability_active:
		ability_time_remaining -= delta
		if ability_time_remaining <= 0:
			deactivate_ability()
	else:
		if cooldown_time_remaining > 0:
			cooldown_time_remaining -= delta
		if Input.is_action_just_pressed("activate_ability") and cooldown_time_remaining <= 0:
			activate_ability()
			
func activate_ability() -> void:
	ability_active = true
	is_immune = true
	fire_rate *= 2
	ability_time_remaining = ability_duration
	cooldown_time_remaining = ability_cooldown + ability_duration
	print_debug("potato")

func deactivate_ability() -> void:
	ability_active = false
	is_immune = false
	fire_rate /= 2

func take_damage(amount: int) -> void:
	if is_immune:
		return
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	# Handle player death (e.g., restart level, show game over screen)
	pass
