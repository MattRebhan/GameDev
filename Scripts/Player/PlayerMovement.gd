class_name Player
extends CharacterBody2D

var CardinalDirection : Vector2 = Vector2.DOWN
var MovementDirection : Vector2 = Vector2.ZERO
var MoveSpeed := 100.0
# Offset from player position in the facing direction
var spawn_offset = CardinalDirection.normalized() * -20  # Tweak '10' as needed




@export var FireballScene : PackedScene
@onready var PlayerAnimation : AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	UpdateAnimation()

func _physics_process(delta):
	var input_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var input_y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	MovementDirection = Vector2(input_x, input_y).normalized()

	if Input.is_action_just_pressed("AltAction"):
		ShootFireball()

	# Save last movement direction as "facing"
	if MovementDirection != Vector2.ZERO:
		CardinalDirection = MovementDirection

	velocity = MovementDirection * MoveSpeed
	move_and_slide()

func ShootFireball():
	if FireballScene == null:
		return

	var fireball = FireballScene.instantiate()
	fireball.global_position = global_position + spawn_offset
	fireball.direction = CardinalDirection.normalized()# Assuming fireball script expects this
	#var projectile_group = get_tree().get_current_scene().get_node("CanvasGroup")
	#projectile_group.add_child(fireball)
	get_tree().current_scene.add_child(fireball)




func UpdateAnimation() -> void:
	var is_moving = MovementDirection.length() > 0

	if abs(CardinalDirection.x) > abs(CardinalDirection.y):
		# Side movement (left/right)
		if is_moving:
			PlayerAnimation.play("WalkSide")
		else:
			PlayerAnimation.play("IdleSide")
		PlayerAnimation.flip_h = CardinalDirection.x < 0
	else:
		if CardinalDirection.y < 0:
			PlayerAnimation.play("WalkUp" if is_moving else "IdleUp")
		else:
			PlayerAnimation.play("WalkDown" if is_moving else "IdleDown")
