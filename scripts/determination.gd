extends CharacterBody2D

@export var SPEED = 300.0
var moveable = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("x"):
		SPEED = 100.0
	else:
		SPEED = 300.0
	if G.battle or moveable:
		$CollisionShape2D.disabled = false
		show()
		var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
		move_and_slide()
	else:
		hide()
		$CollisionShape2D.disabled = true


func _on_hit_area(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("bullet"):
		G.HP -= area.atk
		if area.destructible:
			area.queue_free()
		hit()

func hit():
	G.play("res://sounds/hit.wav")
	$Sprite2D.modulate = Color(1.0, 0.7, 0.652, 1.0)
	$HitArea.position = Vector2(1225,1225)
	await get_tree().create_timer(G.invincible).timeout
	$Sprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)
	$HitArea.position = Vector2(0,0)
	if G.HP <= 0:
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
