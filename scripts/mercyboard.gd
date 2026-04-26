extends NinePatchRect

@export var sel = 0
@onready var B: Node2D = $".."
@export var sels = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(B.ene) >= 1:
		if B.ene[0].mer >= 100 and B.enlf[0]:
			$mercy.modulate = Color(1, 1, 0.0, 1.0)
		else:
			$mercy.modulate = Color(1, 1, 1, 1.0)
	if len(B.ene) >= 2:
		if (B.ene[0].mer >= 100 and B.enlf[0]) or (B.ene[1].mer >= 100 and B.enlf[1]):
			$mercy.modulate = Color(1, 1, 0.0, 1.0)
		else:
			$mercy.modulate = Color(1, 1, 1, 1.0)
	if len(B.ene) >= 3:
		if (B.ene[2].mer >= 100 and B.enlf[2])or (B.ene[0].mer >= 100 and B.enlf[0]) or (B.ene[1].mer >= 100 and B.enlf[1]):
			$mercy.modulate = Color(1, 1, 0.0, 1.0)
		else:
			$mercy.modulate = Color(1, 1, 1, 1.0)
			
	if B.escape:
		sels = 2
		$escape.show()
	else:
		sels =1
		$escape.hide()
	if B.slmode and B.selection == 3:
		show()
		if Input.is_action_just_pressed("ui_down"):
			G.play("res://sounds/choose.wav")
			sel += 1
			if sel+1 > sels:
				sel = 0
		if Input.is_action_just_pressed("ui_up"):
			G.play("res://sounds/choose.wav")
			sel -= 1
			if sel < 0:
				sel = sels - 1
		if Input.is_action_just_pressed("z"):
			G.play("res://sounds/confirm.wav")
			if sel == 0:
				mercy()
				B.slmode = false
				B.enemy_turn()
			if sel == 1:
				G.play("res://sounds/encounter_1.wav")
				print("overworld都还没做，逃啥逃？")
	else:
		hide()
	if sel == 0:
		$sl_soul2.position = $mercy.position + Vector2(-35,25)
	if sel == 1:
		$sl_soul2.position = $escape.position + Vector2(-35,25)

			
func mercy():
	if len(B.ene) >= 1:
		if B.ene[0].mer >= 100 and B.enlf[0]:
			B.got_gold += B.ene[0].gold
			G.play("res://sounds/enemydust.wav")
			B.enlf[0] =  false
			B.ene[0].modulate = Color(1.0, 1.0, 1.0, 0.25)
			B.ene[0].mery = true
	if len(B.ene) >= 2:
		if B.ene[1].mer >= 100 and B.enlf[1]:
			B.got_gold += B.ene[1].gold
			G.play("res://sounds/enemydust.wav")
			B.enlf[1] =  false
			B.ene[1].modulate = Color(1.0, 1.0, 1.0, 0.25)
			B.ene[1].mery = true
	if len(B.ene) >= 3:
		if B.ene[2].mer >= 100 and B.enlf[2]:
			B.got_gold += B.ene[2].gold
			G.play("res://sounds/enemydust.wav")
			B.enlf[2] =  false
			B.ene[2].modulate = Color(1.0, 1.0, 1.0, 0.25)
			B.ene[2].mery = true
	
