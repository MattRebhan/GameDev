class_name fireball
extends Area2D



@export var direction: Vector2 = Vector2.ZERO


var speed = 200.0

func _physics_process(delta):
	position += direction.normalized() * speed * delta
