extends NinePatchRect

@onready var B: Node2D = $".."
@export var sel = 0
@export var atk = false
@export var spd = 750
@export var dontm = false
@export var atked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(B.ene) == 0:
		$VBoxContainer/ename.hide()
		$VBoxContainer/ename2.hide()
		$VBoxContainer/ename3.hide()
	if len(B.ene) == 1:
		$VBoxContainer/ename.text = "* "+B.ene[0].ename
		if len(B.enlf) >= 1:#0.1.3小补丁，拜托企鹅你在干什么，你明明会用大于等于的非要这么麻烦整
			if B.enlf[0]:
				$VBoxContainer/ename.show()
			else:
				$VBoxContainer/ename.hide()
		$VBoxContainer/ename2.hide()
		$VBoxContainer/ename3.hide()
	if len(B.ene) == 2:
		$VBoxContainer/ename.text = "* "+B.ene[0].ename
		$VBoxContainer/ename2.text = "* "+B.ene[1].ename
		if len(B.enlf) >= 1:#鹅，我是说，能跑就行吧，沫子哥别动我石山好吗？
			if B.enlf[0]:#↑你能不能别给我演人格分裂了好吗？
				$VBoxContainer/ename.show()#我现在还缺个血条显示，血条嵌name下面就不要多写代码了(
			else:#企鹅你简直就是人才——2026/3/8 0:33
				$VBoxContainer/ename.hide()
		if len(B.enlf) >= 2:
			if B.enlf[1]:
				$VBoxContainer/ename2.show()
			else:
				$VBoxContainer/ename2.hide()
		$VBoxContainer/ename3.hide()
	if len(B.ene) == 3:
		$VBoxContainer/ename.text = "* "+B.ene[0].ename
		$VBoxContainer/ename2.text = "* "+B.ene[1].ename
		$VBoxContainer/ename3.text = "* "+B.ene[2].ename
		if len(B.enlf) >= 1:
			if B.enlf[0]:
				$VBoxContainer/ename.show()
			else:
				$VBoxContainer/ename.hide()
		if len(B.enlf) >= 2:
			if B.enlf[1]:
				$VBoxContainer/ename2.show()
			else:
				$VBoxContainer/ename2.hide()
		if len(B.enlf) >= 3:
			if B.enlf[2]:
				$VBoxContainer/ename3.show()
			else:
				$VBoxContainer/ename3.hide()
		
	if atk:
		attack(spd * delta)
	if B.slmode and B.selection == 0:
		if B.xe:
			$sl_soul2.show()
			$VBoxContainer.show()
			$SprTarget0.hide()
			$AnimatedSprite2D.hide()
		else:
			$sl_soul2.hide()
			$VBoxContainer.hide()
			$SprTarget0.show()
			$AnimatedSprite2D.show()
		show()
		if B.xe:
			if not B.enlf[sel]:
				sel = B.enlf.find(true)#以防你还选着一个已经似了的家伙-0.1.3小补丁
			if Input.is_action_just_pressed("ui_down"):
				G.play("res://sounds/choose.wav")
				sel += 1
				if sel >= len(B.ene):
					sel = 0
				while not B.enlf[sel]:#0.1.3小补丁
					sel += 1
					if sel >= len(B.ene):
						sel = 0
			if Input.is_action_just_pressed("ui_up"):
				G.play("res://sounds/choose.wav")
				sel -= 1
				if sel < 0:
					sel = len(B.ene)-1
				while not B.enlf[sel]:#0.1.3小补丁
					sel -= 1
					if sel < 0:
						sel = len(B.ene)-1
			if Input.is_action_just_pressed("z") and not atk:
				G.play2("res://sounds/confirm.wav")
				if B.enlf[sel]:
					dontm = false
					B.xe = false
					atk = true
					atked = false
				else:
					G.play2("res://sounds/encounter_1.wav")
	else:
		hide()
	if sel == 0:
		$sl_soul2.position.y = $VBoxContainer/ename.position.y + 65
	if sel == 1:
		$sl_soul2.position.y = $VBoxContainer/ename2.position.y + 65
	if sel == 2:
		$sl_soul2.position.y = $VBoxContainer/ename3.position.y + 65

func attack(speed):
	$AnimatedSprite2D.modulate = Color(0,0,0,0)
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1,1), 0.1)
	if $AnimatedSprite2D.position.x >= 1150:
		atk = false
		var tween2 = get_tree().create_tween()
		tween2.tween_property($AnimatedSprite2D, "modulate", Color(0,0,0,0), 0.5)
		tween2.tween_callback(atkout)
	else:
		if not dontm:
			$AnimatedSprite2D.position.x += speed
	if Input.is_action_just_pressed("z") and not atked:
		atked = true
		await get_tree().create_timer(0).timeout
		atksuc()
func atkout():
	$AnimatedSprite2D.position.x =  40
	B.xe = true
	B.slmode = false
	B.enemy_turn()
func atksuc():
	G.play("res://sounds/slice.wav")
	dontm = true
	$AnimatedSprite2D.play("suc")
	$"../slice".position.x = B.enx[sel] + 115
	$"../slice".show()
	$"../slice".play("slice")
	var hm = B.enhp[sel]
	var reduce = abs($AnimatedSprite2D.position.x - $Marker2D.position.x)/556.0
	var hurt = int((1-reduce) * G.atk) - B.ene[sel].df
	if hurt < 0:
		hurt = 0
	await get_tree().create_timer(0.5).timeout
	B.enhp[sel] -= hurt
	showhp(sel,hm,hurt)
	await get_tree().create_timer(0.5).timeout
	if not B.enlf[sel]:
		G.play2("res://sounds/enemydust.wav")
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.position.x =  40
	B.xe = true
	B.slmode = false
	atk = false
	B.enemy_turn()
func showhp(who,hm,hurt):
	var hpl = load("res://scenes/hurthplabel.tscn").instantiate()
	$"../enhpbar".position.x = B.enx[who] + 55
	hpl.position = $"../enhpbar".position - Vector2(45,35)
	hpl.txt = str(hurt)
	$"../enhpbar".show()
	$"../enhpbar/HPBar".max_value = B.enhm[who]
	$"../enhpbar/HPBar".value = hm
	get_tree().current_scene.add_child(hpl)
	var tween = get_tree().create_tween()
	tween.tween_property($"../enhpbar/HPBar", "value", B.enhp[who], 0.5)
	tween.tween_callback($"../enhpbar".hide)
