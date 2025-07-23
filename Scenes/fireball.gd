class_name FireBall

extends Area2D

@export var direction: Vector2 = Vector2.ZERO
@onready var FireBallAnimation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	rotation = direction.angle()# + deg_to_rad(90)
	FireBallAnimation.play("Fire")  # or whatever your animation is called

var speed = 300.0

func _physics_process(delta):
	position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(25)  # Deal 25 damage
	queue_free()  # Destroy fireball on hit
