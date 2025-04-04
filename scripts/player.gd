extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@export var max_jump_count = 2

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0
		if velocity.x != 0:
			anim.play("walk")
		else:
			anim.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1 
		anim.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
		

		
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZone"):
		call_deferred("reload_scene")
	elif area.is_in_group("LevelEnd"):
		var next_level = area.next_level
		if next_level:
			call_deferred("load_scene", next_level)
		else:
			push_error("Proxima fase não definida em EndLevel")


func reload_scene():
	get_tree().reload_current_scene()
func load_scene(scene_name: String):
	get_tree().change_scene_to_file("res://scenes/" + scene_name + ".tscn")
