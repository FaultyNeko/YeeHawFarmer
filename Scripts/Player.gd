extends CharacterBody2D


const SPEED = 300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes


func _physics_process(delta):
	# Add the gravity.

	# Handle jump.
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if direction == Vector2.ZERO:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Run")
		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
	move_and_slide()
