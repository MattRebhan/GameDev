extends Camera2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	position = position.lerp($"../Player".position, delta*3)
