extends Area2D

@export var atk = 1
@export var destructible = false
@export var speed = 0
@export var dir = Vector2(0,0)

func _process(delta: float) -> void:
	position += speed * dir



func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
