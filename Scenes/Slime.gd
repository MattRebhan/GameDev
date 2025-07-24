extends CharacterBody2D

@export var move_speed := 40.0
@export var bounce_range := 20.0
@export var bounce_interval := 2.0
@export var chase_range := 200.0
@export var attack_range := 50.0
@export var back_off_range := 49.0
@export var disengage_range := 300.0
@onready var Health := $HealthBar  # or get_node("HealthBar")
@export var max_health := 50


@onready var slime_anim := $AnimatedSprite2D

var target : Node2D = null
var distance_to_player = 0.0
var bounce_timer := 0.0
var bounce_direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var current_health := max_health
var Chaseing := false

func _physics_process(delta):
	if Chaseing == false:
		# Idle bounce when no target
		bounce_timer -= delta
		if bounce_timer <= 0:
			bounce_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			bounce_timer = bounce_interval
		velocity = bounce_direction * (move_speed * 0.5)

	if target != null:
		distance_to_player = global_position.distance_to(target.global_position)
		
		if distance_to_player > disengage_range:
			Chaseing = false
			target = null
		elif distance_to_player < back_off_range:
			var direction = (global_position - target.global_position).normalized()
			velocity = direction * move_speed
		elif distance_to_player <= attack_range:
			velocity = Vector2.ZERO
		elif distance_to_player < chase_range:
			Chaseing = true
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * move_speed

	move_and_slide()
	update_animation()  # <-- Always run this, even when not chasing


func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)  # Avoid negatives

	# Update the progress bar
	Health.value = current_health

	# Optional: check if slime should die
	if current_health <= 0:
		queue_free()  # Destroys the slime node




func update_animation():
	var direction = Vector2.ZERO

	if target and distance_to_player <= chase_range:
		direction = (target.global_position - global_position).normalized()
	elif velocity.length() > 0:
		direction = velocity.normalized()


	if direction.length() > 0:
		last_direction = direction
	else:
		direction = last_direction

	var anim_prefix = "Walk" if target else "Idle"

	if abs(direction.x) > abs(direction.y):
		slime_anim.play(anim_prefix + "Side")
		slime_anim.flip_h = direction.x < 0
	elif direction.y < 0:
		slime_anim.play(anim_prefix + "Up")
		slime_anim.flip_h = false
	else:
		slime_anim.play(anim_prefix + "Down")
		slime_anim.flip_h = false


func _on_detection_area_body_entered(body):
	if body.name == "Player":  # Or check for group
		target = body


func _on_detection_area_body_exited(body):
	if body == target:
		target = null
