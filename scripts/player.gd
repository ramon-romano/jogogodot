extends CharacterBody2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if velocity.x != 0: 
			anima.play("walk")
		elif velocity.x == 0:
			anima.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anima.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		anima.flip_h = false 
	elif velocity.x < 0:
		anima.flip_h = true
		
	move_and_slide()
