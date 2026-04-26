extends NinePatchRect

@onready var B: Node2D = $".."
@export var sel = 0
@export var page = 0
@export var sl = Vector2(0,0)

func _ready() -> void:
	sl = Vector2(0,0)
func _process(delta: float) -> void:
	if sl == Vector2(0,0):
		$page2/sl_soul.position = $page2/iname1.position + Vector2(-35,25)
	if sl == Vector2(1,0):
		$page2/sl_soul.position = $page2/iname2.position + Vector2(-35,25)
	if sl == Vector2(0,1):
		$page2/sl_soul.position = $page2/iname3.position + Vector2(-35,25)
	if sl == Vector2(1,1):
		$page2/sl_soul.position = $page2/iname4.position + Vector2(-35,25)
	if page == 0:
		$page2.hide()
		$msg.hide()
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
	elif page == 1:
		$msg.hide()
		$page2/iname1.text = ""
		$page2/iname2.text = ""
		$page2/iname3.text = ""
		$page2/iname4.text = ""
		if len(B.ene[sel].act) >= 1:
			$page2/iname1.text = "* "+str(G.actmsg[B.ene[sel].act[0]][0])
		if len(B.ene[sel].act) >= 2:
			$page2/iname2.text = "* "+str(G.actmsg[B.ene[sel].act[1]][0])
		if len(B.ene[sel].act) >= 3:
			$page2/iname3.text = "* "+str(G.actmsg[B.ene[sel].act[2]][0])
		if len(B.ene[sel].act) >= 4:
			$page2/iname4.text = "* "+str(G.actmsg[B.ene[sel].act[3]][0])
		$VBoxContainer.hide()
		$sl_soul2.hide()
		$page2.show()
	else:
		$page2.hide()
		$VBoxContainer.hide()
		$sl_soul2.hide()
		$msg.show()
	if B.slmode and B.selection == 1:
		if B.xe:
			$sl_soul2.show()
			$VBoxContainer.show()
		else:
			$sl_soul2.hide()
			$VBoxContainer.hide()
		show()
		if B.xe:
			if not B.enlf[sel]:
				sel = B.enlf.find(true)#以防你还选着一个已经似了的家伙
			if Input.is_action_just_pressed("ui_down"):
				G.play("res://sounds/choose.wav")
				sel += 1
				if sel >= len(B.ene):
					sel = 0
				while not B.enlf[sel]:
					sel += 1
					if sel >= len(B.ene):
						sel = 0
			if Input.is_action_just_pressed("ui_up"):
				G.play("res://sounds/choose.wav")
				sel -= 1
				if sel < 0:
					sel = len(B.ene)-1
				while not B.enlf[sel]:
					sel -= 1
					if sel < 0:
						sel = len(B.ene)-1
			if Input.is_action_just_pressed("z"):
				if page == 0:
					G.play2("res://sounds/confirm.wav")
					if B.enlf[sel]:
						sl = Vector2(0,0)
						page = 1
						B.xe = false
					else:
						G.play2("res://sounds/encounter_1.wav")
		else:
			if Input.is_action_just_pressed("x"):
				if page == 1:
					B.xe = true
					page = 0
				if page == 2:
					$msg.comp()
			if Input.is_action_just_pressed("z"):
				if page == 1:
					page = 2
					B.ene[sel].mer += G.actmsg[B.ene[sel].act[sll()]][1]
					if B.ene[sel].act[sll()] == 1:#这里选择了查看
						putput("* "+B.ene[sel].ename+" - 攻击 "+str(B.ene[sel].atk)+" 防御 "+str(B.ene[sel].fakedf)
						+"[br]* "+B.ene[sel].info)
					elif B.ene[sel].act[sll()] == 3:#各种行动请看global
						$"../TexRect2".show()
						putput(str(G.actmsg[B.ene[sel].act[sll()]][2]))
					else:
						putput(str(G.actmsg[B.ene[sel].act[sll()]][2]))
				if page == 2 and $msg.completed:
					B.xe = true
					B.slmode = false
					page = 0
					B.enemy_turn()
			if page == 1:
				if Input.is_action_just_pressed("ui_down"):
					G.play("res://sounds/choose.wav")
					sl.y += 1
					if sl.y > 1:
						sl.y = 0
					if len(B.ene[sel].act) < sll()+1:
						sl.y = 0
				if Input.is_action_just_pressed("ui_up"):
					G.play("res://sounds/choose.wav")
					sl.y -= 1
					if sl.y < 0:
						sl.y = 1
					if len(B.ene[sel].act) < sll()+1:
						sl.y = 0
				if Input.is_action_just_pressed("ui_right"):
					G.play("res://sounds/choose.wav")
					sl.x += 1
					if sl.x > 1:
						sl.x = 0
					if len(B.ene[sel].act) < sll()+1:
						sl.x = 0
				if Input.is_action_just_pressed("ui_left"):
					G.play("res://sounds/choose.wav")
					sl.x -= 1
					if sl.x < 0:
						sl.x = 1
					if len(B.ene[sel].act) < sll()+1:
						sl.x = 0
	else:
		hide()
	if sel == 0:
		$sl_soul2.position.y = $VBoxContainer/ename.position.y + 65
	if sel == 1:
		$sl_soul2.position.y = $VBoxContainer/ename2.position.y + 65
	if sel == 2:
		$sl_soul2.position.y = $VBoxContainer/ename3.position.y + 65

func sll():
	return sl.x+sl.y*2

func putput(txt):
	$msg.type(txt)
